class WorksController < ApplicationController

	# MODULES
	# ------------------------------------------------------------
	include Curated

	# PUBLIC METHODS
	# ------------------------------------------------------------
	# GET
	# ............................................................
	def index
		find_works
		@top_appearers = Character.top_appearers
	end

	def curated_index
		@works = @parent.works.order_by(params[:sort]).page(params[:page])
		render 'curated_index'
	end

	def show
		find_work

		if user_signed_in? && @work.editable?(current_user)
			@chapters = @work.chapters
			@notes    = @work.notes
			render 'show'
		# add if hidden
			# render restricted
		elsif @work.chapters.length > 0
			# redirect to first chapter
			redirect_to work_chapter_path(@work, @work.chapters.first)
		elsif @work.notes.length > 0
			# redirect to notes index
			redirect_to work_notes_path(@work)
		else
			render 'restrict'
		end
	end

	def new
		@work = Work.new
		@work.appearances.build
		define_components
	end

	def edit
		find_work
		define_components
	end

	# POST
	# ............................................................
	def create
		add_characters
		@work = Work.new(work_params)

		if @work.save
			redirect_to @work
		else
			define_components
			render action: 'new'
		end
	end

	# PATCH/PUT
	# ............................................................
	def update
		find_work
		add_characters

		if @work.update(work_params)
			redirect_to @work
		else
			define_components
			render action: 'edit'
		end
	end

	# DELETE
	# ............................................................
	def destroy
		@work.destroy
		respond_to do |format|
			format.html { redirect_to works_url }
			format.json { head :no_content }
		end
	end

	# PRIVATE METHODS
	# ------------------------------------------------------------
	private

	# find all
	def find_works
		@works = Work.order_by(params[:sort]).includes(:user).page(params[:page])
	end

	# find by id
	def find_work
		@work = Work.find(params[:id])
	end

	# define strong parameters
	def work_params
		params.require(:work).permit(:title, :user_id, :summary, 
			appearances_attributes: [:id, :character_id, :role, :_destroy],
			conceptions_attributes: [:id, :concept_id, :_destroy]
		)
	end

	# setup form components
	def define_components
		@conceptions = @work.concepts.pluck(:name)
		@connections = Array.new
		@charnest    = Nest.new("Characters", :appearances, "works/nested_forms/appearance_fields")
	end

	def add_characters
		appearances = params[:work][:appearances_attributes]
		appearances.each do |appearance|
			char_id = appearance[1][:character_id]
			is_int  = Integer(char_id, 10) rescue false
			if !(is_int || char_id.empty?)
				character = Character.where(name: char_id).first_or_create
				appearance[1][:character_id] = character.id
			end
		end
	end
end
