class Users::PenNamingsController < ApplicationController

	# OUTPUT FORMATS
	# ------------------------------------------------------------
	respond_to :html, :js, :json

	# FILTERS
	# ------------------------------------------------------------
	before_action :find_pen_name, only: [:show, :update, :create]

	# PUBLIC METHODS
	# ------------------------------------------------------------
	# GET
	# ............................................................
	def index
		unless user_signed_in?
			redirect_to new_user_session_path
		end
		find_pen_names
	end

	def show
	end

	def new
		@namer = PenNaming.new
		@namer.new_character
	end

	def edit
		@namer = PenNaming.find(params[:id])
	end

	# POST
	# ............................................................
	def create
		@namer = current_user.pen_namings.create(pen_naming_params)
		@namer.set_uploader
		find_pen_names
	end

	# PATCH/PUT
	# ............................................................
	def update
		if @namer.update(pen_naming_params)
			respond_to do |format|
				format.js
				format.html { redirect_to @namer }
			end
		else
			render action: 'edit'
		end
	end

	# PRIVATE METHODS
	# ------------------------------------------------------------
	private
	# get all
	def find_pen_names
		@pen_names = PenNamingsDecorator.decorate(current_user.pen_namings)
	end

	def find_pen_name
		@namer = PenNaming.find(params[:id])

		unless @namer.user.id == current_user.id
			redirect_to new_user_session_path
		end
		@namer = @namer.decorate
	end

	# define strong parameters
	def pen_naming_params
		params.require(:pen_naming).permit(character_attributes: [:id, :name])
	end

end