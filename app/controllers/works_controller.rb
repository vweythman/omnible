class WorksController < ApplicationController

	# FILTERS
	# ------------------------------------------------------------
	before_action :begin_work, only: [:new]
	before_action :find_viewable_work, except: [:index, :new, :create]

	# MODULES
	# ------------------------------------------------------------
	include ContentCollections

	# PUBLIC METHODS
	# ------------------------------------------------------------
	# GET
	# ............................................................
	def index
		find_works
	end

	def show
		if @work.viewable?(current_user)

			#redirect_to @work
		#elsif @work.upcoming?
			render 'upcoming'
		else
			render 'restrict'
		end
	end

	def new
	end

	def edit
		define_components
	end

	# POST
	# ............................................................
	def create
		@work = Work.new(work_params)

		if @work.save
			add_characters
			redirect_to @work
		else
			define_components
			render action: 'new'
		end
	end

	# PATCH/PUT
	# ............................................................
	def update
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

	# CRUD METHODS
	# ............................................................
	# setup work
	def begin_work
		@work = Work.new
		@work.appearances.build
		define_components
	end

	# find all with options from a filter
	def find_works
		@works = Work.with_filters(index_params, current_user).decorate
	end

	# ensures that a viewer can view
	def find_viewable_work
		@work = Work.find(params[:id]).decorate

		if !@work.viewable? current_user
			render 'restrict'
		end
	end

	# PARAMS
	# ............................................................
	# clean index params
	def index_params
		params.slice(:date, :sort, :rating, :rating_min, :rating_max, :page)
	end

	# define strong parameters
	def work_params
		params.require(:work).permit(:title, :uploader_id, :summary, :publicity_level, :editor_level, 
			appearances_attributes: [:id, :character_id, :role, :_destroy],
			rating_attributes:      [:id, :violence, :sexuality, :language]
		)
	end

end
