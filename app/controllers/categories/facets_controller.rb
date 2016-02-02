class Categories::FacetsController < ApplicationController

	# FILTERS
	# ============================================================
	# FIND
	# ------------------------------------------------------------
	before_action :facet,  except: [:index, :new, :create]
	before_action :facets, only:   [:index]

	# PERMIT
	# ------------------------------------------------------------
	before_action :can_create?,  only: [:new,  :create]
	before_action :can_edit?,    only: [:edit, :update]
	before_action :can_destroy?, only: [:destroy]

	# PUBLIC METHODS
	# ============================================================
	# GET
	# ------------------------------------------------------------
	def show
		@identities = @facet.identities.decorate
	end

	def new
		@facet = Facet.new.decorate
	end

	# POST
	# ------------------------------------------------------------
	def create
		@facet = Facet.new(facet_params).decorate

		if @facet.save
			respond_to do |format|
				format.js   { find_facets }
				format.html { redirect_to @facet }
			end
		else
			render action: 'edit'
		end
	end

	# PATCH/PUT
	# ------------------------------------------------------------
	def update
		if @facet.update(category_params)
			redirect_to @facet
		else
			render action: 'edit'
		end
	end

	# DELETE
	# ------------------------------------------------------------
	def destroy
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
	
	def can_destroy?
		unless @facet.destroyable? current_user
			redirect_to @facet
		end
	end
	
	def can_edit?
		unless @facet.editable? current_user
			redirect_to @facet
		end
	end

end