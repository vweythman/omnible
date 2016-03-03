class Users::PenNamingsController < ApplicationController

	# FILTERS
	# ============================================================
	before_action :can_view?, only: [:index, :show]

	# PUBLIC METHODS
	# ============================================================
	# GET
	# ------------------------------------------------------------
	def index
		pen_names
	end

	def show
		pen_name
	end

	def new
		@pen = PenNaming.new
		@pen.new_character
	end

	def edit
		pen_name
	end

	# POST
	# ------------------------------------------------------------
	def create
		@pen = PenNaming.new(pen_naming_params)

		@pen.user = current_user
		@pen.save
		@pen.set_character_behavior
		@pen.character.save
		
		pen_names
	end

	# PATCH/PUT
	# ------------------------------------------------------------
	def update
		pen_name
		can_show_view?
		if @pen.update(pen_naming_params)
			respond_to do |format|
				format.js
				format.html { redirect_to @pen }
			end
		else
			render action: 'edit'
		end
	end

	#
	def destroy
		pen_name
		@pen.destroy

		respond_to do |format|
			format.html { redirect_to dashboard_path }
			format.json { head :no_content }
		end
	end

	# PRIVATE METHODS
	# ------------------------------------------------------------
	private

	# get all
	def pen_names
		@pen_names = PenNamingsDecorator.decorate(current_user.pen_namings)
	end

	def pen_name
		@pen = PenNaming.find(params[:id]).decorate
	end

	# define strong parameters
	def pen_naming_params
		params.require(:pen_naming).permit(character_attributes: [:id, :name])
	end

	def can_view?
		unless user_signed_in?
			redirect_to new_user_session_path
		end
	end

	def can_show_view?
		unless @pen.user.id == current_user.id
			redirect_to new_user_session_path
		end
	end

end