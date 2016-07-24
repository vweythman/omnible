class Subjects::SquadsController < SubjectsController

	# PUBLIC METHODS
	# ============================================================
	# GET
	# ------------------------------------------------------------
	def index
		find_squads
	end

	def show
		find_squad
	end

	def new
		@squad = Squad.new
		@squad = @squad.decorate
	end

	def edit
		find_squad
	end

	# POST
	# ------------------------------------------------------------
	def create
		@squad = Squad.new(squad_params).decorate
		@squad.uploader = current_user
		@squad.visitor  = current_user

		if @squad.save
			redirect_to @squad
		else
			render action: 'new'
		end
	end

	# PATCH/PUT
	# ------------------------------------------------------------
	def update
		@squad         = Squad.find(params[:id]).decorate
		@squad.visitor = current_user

		respond_to do |format|
			if @squad.update(squad_params)
				format.html { redirect_to @squad }
				format.json { head :no_content }
			else
				format.html { render action: 'edit' }
				format.json { render json: @squad.errors, status: :unprocessable_entity }
			end
		end
	end

	# PRIVATE METHODS
	# ============================================================
	private

	def squad_params
		params.require(:squad).permit(
			:name, :label,  :description,
			:tags, :people, :relateables
		)
	end

	# FIND
	# ------------------------------------------------------------
	def find_squads
		@subjects = @squads = Collectables::SquadsDecorator.decorate Squad.order('name')
	end

	def find_squad
		@squad = Squad.find(params[:id]).decorate
	end
end
