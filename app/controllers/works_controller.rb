class WorksController < ApplicationController

	# MODULES
	# ============================================================
	include ContentCollections

	# PUBLIC METHODS
	# ============================================================
	# GET
	# ------------------------------------------------------------
	def index
		works
	end

	def show
		work

		cannot_view? @work do
			render 'works/restricted/show'
		end

		find_comments
	end

	def new
		new_work
		set_editables
	end

	def edit
		work

		cannot_edit? @work do
			return
		end

		set_editables
	end

	# POST
	# ------------------------------------------------------------
	def create
		created_work
		set_visitor

		if @work.save
			redirect_to @work
		else
			render action: 'new'
		end
	end

	# PATCH/PUT
	# ------------------------------------------------------------
	def update
		work

		cannot_edit? @work do
			return
		end

		set_visitor

		if @work.update(work_params)
			redirect_to @work
		else
			render action: 'edit'
		end
	end

	# DELETE
	# ------------------------------------------------------------
	def destroy
		work

		cannot_destroy? @work do
			return
		end

		@work.destroy

		respond_to do |format|
			format.html { redirect_to works_url }
			format.json { head :no_content }
		end
	end

	# PRIVATE METHODS
	# ============================================================
	private

	# CLEAN
	# ------------------------------------------------------------
	# WorkParams :: define strong parameters
	def work_params
		base_work_params
	end

	def base_work_params(type = :work)
		params.require(type).permit(Work.permitted_model_params)
	end

	def index_params
		params.slice(Work.permitted_index_params)
	end

	def decorator
		"Collectables::WorksDecorator".classify.constantize
	end

	# FIND
	# ------------------------------------------------------------
	# Work :: find by id
	def work
		@work = Work.find(params[:id]).decorate
	end

	# Works :: find all with filtering
	def works
		@works = decorator.decorate Work.toggle_links(show_links).with_filters(index_params, current_user)
	end

	# SET
	# ------------------------------------------------------------
	def created_work
		@work = Work.new(work_params).decorate
	end

	def new_work
		@work = Work.new.decorate
		@work.form_setup(params)
		@work.rating = Rating.new
	end

	def show_links
		@show_links ||= params[:show_links] || false
	end

	# FORM
	# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	def set_editables
		set_visitor
		set_create_as
	end

	def set_visitor
		@work.uploader ||= current_user
		@work.visitor    = current_user
	end

	def set_create_as
		if params[:create_as].nil?
			@create_as = nil
		else
			@create_as = @work.created_by params[:create_as]
		end
	end

end
