class WorksController < ApplicationController

	# FILTERS
	# ============================================================
	# FIND
	# ------------------------------------------------------------
	before_action :work, only: [:show, :edit, :update, :destroy]

	# PERMIT
	# ------------------------------------------------------------
	before_action :can_edit?, except: [:index, :show, :new, :create]
	before_action :can_view?, only:   [:show]

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
		find_comments
	end

	def new
		new_work
		set_visitor
		set_skin
	end

	def edit
		set_visitor
		set_skin
	end

	# POST
	# ------------------------------------------------------------
	def create
		@work = Work.new(work_params).decorate
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
		params.require(:work).permit(
			:title,        :summary,         :visitor,
			:editor_level, :publicity_level, :placeables,   :taggables,

			uploadership:        [:category, :pen_name],
			skinning_attributes: [:id,       :skin_id,  :_destroy],
			appearables:         [:main,     :side,     :mentioned, :subject],
			rating_attributes:   [:id,       :violence, :sexuality, :language]
		)
	end

	def index_params
		params.slice(:date, :sort, :completion, :rating, :rating_min, :rating_max, :page)
	end

	# FIND
	# ------------------------------------------------------------
	# Work :: find by id
	def work
		@work = Work.find(params[:id]).decorate
	end

	# Works :: find all with filtering
	def works
		@works = Work.with_filters(index_params, current_user).decorate
	end

	# SET
	# ------------------------------------------------------------
	def new_work
		@work = Work.new.decorate
		@work.rating = Rating.new
	end

	def set_visitor
		@work.uploader ||= current_user
		@work.visitor    = current_user
	end

	def set_skin
		@work.skinning ||= Skinning.new
	end

	# PERMIT
	# ------------------------------------------------------------
	def can_view?
		if !@work.viewable? current_user
			render 'restrict'
		end
	end

	def can_edit?
		unless @work.editable? current_user
			redirect_to @work
		end
	end

end