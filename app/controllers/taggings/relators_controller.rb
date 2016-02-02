class Taggings::RelatorsController < TaggingsController

	# FILTERS
	# ============================================================
	before_action :tags,         only: [:index]
	before_action :can_create?,  only: [:new, :create]
	before_action :can_edit?,    only: [:edit, :update]

	# PUBLIC METHODS
	# ============================================================
	# GET
	# ------------------------------------------------------------
	def index
	end

	def new
		@tag = @relator = Relator.new.decorate
	end

	# POST
	# ------------------------------------------------------------
	def create
		@relator = Relator.new(tag_params)

		if @relator.save
			respond_to do |format|
				format.js   { tags }
				format.html { redirect_to @relator }
			end
		else
			render action: 'edit'
		end
	end

	# PRIVATE METHODS
	# ============================================================
	private

	# CLEAN
	# ------------------------------------------------------------
	# TagParams :: define strong parameters
	def tag_params
		params.require(:relator).permit(:right_name, :left_name, 
			interconnections_attributes: [:id, :left_id, :right_id, :_destroy]
		)
	end

	# FIND
	# ------------------------------------------------------------
	# Tag :: find by id
	def tag
		@tag = @relator = Relator.find(params[:id]).decorate
	end
	
	# Tags :: find all
	def tags
		@tags = Relator.order('left_name').all.decorate
	end

	# PERMIT
	# ------------------------------------------------------------
	def can_create?
		unless Relator.createable? current_user 
			redirect_to relators_path
		end
	end
	
	def can_edit?
		unless @relator.editable? current_user
			redirect_to @relator
		end
	end

end
