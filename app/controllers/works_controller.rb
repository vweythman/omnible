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
		find_works
		render 'curated_index'
	end

	def show
		find_work

		if user_signed_in? && @work.editable?(current_user)
			@user     = @work.user
			@chapters = @work.chapters
			@notes    = @work.notes

			@characters = @work.organized_characters
			@user       = @work.user
			@tags       = @work.tags
			render 'show'
		# add if !@work.viewable?(curent_user)
			# render restrict
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
		if @parent.nil?
			@works = Work.assort(params[:date], params[:sort]).includes(:user).page(params[:page])
		else
			@works = @parent.works.assort(params[:date], params[:sort]).includes(:user).page(params[:page])
		end
	end

	# find by id
	def find_work
		@work = Work.find(params[:id])
	end

	# define strong parameters
	def work_params
		params.require(:work).permit(:title, :user_id, :summary, 
			appearances_attributes: [:id, :character_id, :role, :_destroy]
		)
	end

	# setup form components
	def define_components
		@characters = Character.order('lower(name)').all
		@tags       = @work.tags.pluck(:name)
		@charnest   = Nest.new("Characters", :appearances, "works/nested_forms/appearance_fields")
	end

	def add_characters
		appearances = params[:work][:appearances_attributes]
		appearances.each do |appearance|
			char_id = appearance[1][:character_id]
			is_int  = Integer(char_id, 10) rescue false
			if !(is_int || char_id.empty?)
				character = Character.where(name: char_id, uploader_id: current_user.id).create
				appearance[1][:character_id] = character.id
			end
		end
	end
end
