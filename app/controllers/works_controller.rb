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

		if @work.viewable?(current_user)

			#redirect_to @work
		#elsif @work.upcoming?
			render 'upcoming'
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
		options = params.slice(:date, :sort, :rating, :rating_min, :rating_max)
		if @parent.nil?
			@works = Work.assort(options).page(params[:page])
		else
			@works = @parent.works.assort(options).page(params[:page])
		end
	end

	# find by id
	def find_work
		@work = Work.find(params[:id])
	end

	# define strong parameters
	def work_params
		params.require(:work).permit(:title, :uploader_id, :summary, 
			appearances_attributes: [:id, :character_id, :role, :_destroy]
		)
	end

	# setup form components
	def define_components
		@general_tags = @work.tags.pluck(:name)
		@characters   = @work.init_characters
	end

	def add_characters
		new_appears = Character.batch Appearance.update_for(@work, params), current_user
		params[:work][:appearances_attributes] = new_appears
	end
end
