class WorksController < ApplicationController

	# FILTERS
	# ------------------------------------------------------------
	before_action :begin_work,           only: [:new]
	before_action :setup_tags,           only: [:create]
	before_action :find_editable_work,   only: [:edit, :update, :delete]
	before_action :find_viewable_work, except: [:index, :new, :create, :edit, :update]

	# MODULES
	# ------------------------------------------------------------
	include ContentCollections
	include FacetedWorkTags

	# PUBLIC METHODS
	# ------------------------------------------------------------
	# GET
	# ............................................................
	def index
		find_works
	end

	def show
	end

	def new
	end

	def edit
	end

	# POST
	# ............................................................
	def create
		@work = Work.new(work_params)

		if @work.save
			redirect_to @work
		else
			render action: 'new'
		end
	end

	# PATCH/PUT
	# ............................................................
	def update
		update_tags(@work)
		if @work.update(work_params)
			redirect_to @work
		else
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
	# FOR INDEX :: find all with options from a filter
	def find_works
		@works = Work.with_filters(index_params, current_user).decorate
	end

	# FOR SHOW :: ensures that a viewer can view
	def find_viewable_work
		@work = Work.find(params[:id]).decorate

		if !@work.viewable? current_user
			render 'restrict'
		end
	end

	# FOR NEW :: setup work
	def begin_work
		@work = Work.new
		@work.appearances.build
	end

	# FOR EDIT & DELETE :: ensures that a editor can edit or delete
	def find_editable_work
		@work = Work.find(params[:id]).decorate

		unless @work.editable? current_user
			redirect_to @work
		end
	end

	# PARAMS
	# ............................................................
	# clean index params
	def index_params
		params.slice(:date, :sort, :completion, :rating, :rating_min, :rating_max, :page)
	end

	# set tag creation
	def setup_tags
		create_tags(:article, false)
	end

	# define strong parameters
	def work_params
		params.require(:work).permit(:title, :uploader_id, :summary, :publicity_level, :editor_level, 
			appearances_attributes: [:id, :character_id, :role, :_destroy],
			settings_attributes:    [:id, :place_id, :_destroy],
			rating_attributes:      [:id, :violence, :sexuality, :language]
		)
	end

end
