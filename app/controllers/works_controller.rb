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
		set_visitor
		set_skin
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
		params.require(type).permit(
			:title,        :summary,         :visitor,    :status,
			:editor_level, :publicity_level, :placeables, 

			uploadership:        [:category,   :pen_name],
			skinning_attributes: [:id,         :skin_id,   :_destroy],
			rating_attributes:   [:id,         :violence,  :sexuality, :language],

			appearables:         [:main,       :side,      :mentioned, :subject],
			socialables:         [:main_ship,  :side_ship, :anti_ship, :social_group],
			taggables:           [:commentary, :general,   :warning,   :genre], 
			relateables:         [:general,    :setting,   :reference, :subject, :cast]
		)
	end

	def index_params
		params.slice(
			:date,    :sort,       :completion, :page, 
			:vrating, :srating,    :prating,
			:rating,  :rating_min, :rating_max, 
			:with,    :without,    :content_type
		)
	end

	# FIND
	# ------------------------------------------------------------
	# Work :: find by id
	def work
		@work = Work.find(params[:id]).decorate
	end

	# Works :: find all with filtering
	def works
		@works = Collectables::WorksDecorator.decorate Work.toggle_links(show_links).with_filters(index_params, current_user)
	end

	# SET
	# ------------------------------------------------------------
	def created_work
		@work = Work.new(work_params).decorate
	end

	def new_work
		@work = Work.new.decorate
		@work.rating = Rating.new
	end

	def set_editables
		set_visitor
		set_skin
	end

	def set_visitor
		@work.uploader ||= current_user
		@work.visitor    = current_user

		if params[:create_as].nil?
			@create_as = nil
		else
			@create_as = current_user.pseudonymings.find_by_id(params[:create_as]).character
		end
	end

	def set_skin
		@work.skinning ||= Skinning.new
	end

	def show_links
		@show_links ||= params[:show_links] || false
	end

end
