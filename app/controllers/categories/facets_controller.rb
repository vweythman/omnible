class Categories::FacetsController < ApplicationController

	# FILTERS
	# ============================================================
	# PERMIT
	# ------------------------------------------------------------
	before_action :can_create?, only: [:new, :create]

	# PUBLIC METHODS
	# ============================================================
	# GET
	# ------------------------------------------------------------
	def index
		facets
	end

	def show
		facet
		@identities = @facet.identities.decorate
	end

	def new
		@facet = Facet.new.decorate
	end

	def edit
		facet
		can_edit? @facet
	end

	# POST
	# ------------------------------------------------------------
	def create
		@facet = Facet.new(facet_params).decorate

		if @facet.save
			respond_to do |format|
				format.js   { facets }
				format.html { redirect_to @facet }
			end
		else
			render action: 'edit'
		end
	end

	# PATCH/PUT
	# ------------------------------------------------------------
	def update
		facet

		cannot_edit? @facet do
			redirect_to @facet
			return
		end

		if @facet.update(facet_params)
			respond_to do |format|
				format.js   {  }
				format.html { redirect_to @facet }
			end
		else
			render action: 'edit'
		end
	end

	# DELETE
	# ------------------------------------------------------------
	def destroy
		facet

		cannot_destroy? @facet do
			return
		end

		@facet.destroy

		respond_to do |format|
			format.js   { facets }
			format.html { redirect_to facets_path }
		end
	end

	# PRIVATE METHODS
	# ============================================================
	private

	# CLEAN
	# ------------------------------------------------------------
	# define strong parameters
	def facet_params
		params.require(:facet).permit(:name)
	end

	# FIND
	# ------------------------------------------------------------
	def facets
		@facets = Facet.order('lower(name)').all.decorate
	end

	def facet
		@facet = Facet.friendly.find(params[:id]).decorate
	end

	# PERMIT
	# ------------------------------------------------------------
	def can_create?
		unless Facet.createable? current_user 
			redirect_to facets_path
		end
	end

end