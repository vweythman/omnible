class Taggings::FacetsController < ApplicationController

	# FILTERS
	# ------------------------------------------------------------
	before_action :find_facet,         except: [:index, :new, :create]
	before_action :ensure_createable,  only:   [:new, :create]
	before_action :ensure_editable,    only:   [:edit, :update]
	before_action :ensure_destroyable, only:   [:destroy]

	# PUBLIC METHODS
	# ------------------------------------------------------------
	# GET
	# ............................................................
	def index
		find_facets 
	end

	def show
		@facet      = @facet.decorate
		@identities = @facet.identities.decorate
	end

	def new
		@facet = Facet.new
	end

	def edit
	end

	# POST
	# ............................................................
	def create
		@facet = Facet.new(facet_params)
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
	# ............................................................
	def update
	end

	# DELETE
	# ............................................................
	def destroy

	end

	# PRIVATE METHODS
	# ------------------------------------------------------------
	private

	# define strong parameters
	def facet_params
		params.require(:facet).permit(:name)
	end

	# MODEL FIDERS
	# ............................................................
	def find_facets
		@facets = Facet.order('lower(name)').all.decorate
	end

	def find_facet
		@facet = Facet.friendly.find(params[:id])
	end

	# USER PERMISSIONS
	# ............................................................
	def ensure_createable
		unless Facet.createable? current_user 
			redirect_to facets_path
		end
	end
	
	def ensure_destroyable
		unless @facet.destroyable? current_user
			redirect_to @facet
		end
	end
	
	def ensure_editable
		unless @facet.editable? current_user
			redirect_to @facet
		end
	end

end
