class Taggings::RelatorsController < TaggingsController

	# FILTERS
	# ------------------------------------------------------------
	before_action :find_tags,          only: [:index]
	before_action :ensure_createable,  only: [:new, :create]
	before_action :ensure_editable,    only: [:edit, :update]
	before_action :ensure_destroyable, only: [:destroy]

	# PUBLIC METHODS
	# ------------------------------------------------------------
	# GET
	# ............................................................
	def index
	end

	def new
		@tag = @relator = Relator.new.decorate
	end

	# POST
	# ............................................................
	def create
		@relator = Relator.new(tag_params)

		if @relator.save
			respond_to do |format|
				format.js   { find_tags }
				format.html { redirect_to @relator }
			end
		else
			render action: 'edit'
		end
	end

	# PRIVATE METHODS
	# ------------------------------------------------------------
	private

	# define strong parameters
	def tag_params
		params.require(:relator).permit(:right_name, :left_name, 
			interconnections_attributes: [:id, :left_id, :right_id, :_destroy]
		)
	end

	# MODEL FIDERS
	# ............................................................
	def find_tags
		@tags = Relator.order('left_name').all.decorate
	end

	def find_tag
		@tag = @relator = Relator.find(params[:id]).decorate
	end

	# USER PERMISSIONS
	# ............................................................
	def ensure_createable
		unless Relator.createable? current_user 
			redirect_to relators_path
		end
	end
	
	def ensure_destroyable
		unless @relator.destroyable? current_user
			redirect_to @relator
		end
	end
	
	def ensure_editable
		unless @relator.editable? current_user
			redirect_to @relator
		end
	end

end
