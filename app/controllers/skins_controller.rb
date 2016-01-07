class SkinsController < ApplicationController

	# FILTERS
	# ------------------------------------------------------------
	before_action :restrict_visibility
	before_action :set_skin, only: [:show, :edit, :update, :destroy]

	# PUBLIC METHODS
	# ------------------------------------------------------------
	# GET
	# ............................................................
	def index
		@skins = Skin.general_use
	end

	def show
	end

	def new
		@skin = Skin.new
	end

	def edit
	end

	# POST
	# ............................................................
	def create
		@skin = current_user.skins.new(skin_params)

		respond_to do |format|
			if @skin.save
				format.html { redirect_to @skin, notice: 'User skin was successfully created.' }
				format.json { render action: 'show', status: :created, location: @skin }
			else
				format.html { render action: 'new' }
				format.json { render json: @skin.errors, status: :unprocessable_entity }
			end
		end
	end

	# PATCH/PUT
	# ............................................................
	def update
		respond_to do |format|
			if @skin.update(skin_params)
				format.html { redirect_to @skin, notice: 'User skin was successfully updated.' }
				format.json { head :no_content }
			else
				format.html { render action: 'edit' }
				format.json { render json: @skin.errors, status: :unprocessable_entity }
			end
		end
	end

	# DELETE
	# ............................................................
	def destroy
		@skin.destroy
		respond_to do |format|
			format.html { redirect_to skins_url }
			format.json { head :no_content }
		end
	end

	# PRIVATE METHODS
	# ------------------------------------------------------------
	private

	def restrict_visibility
		unless user_signed_in?
			redirect_to root_url
		end
	end

	def set_skin
		@skin = Skin.find(params[:id]).decorate
	end

	def skin_params
		params.require(:skin).permit(:title, :style, :status)
	end

end
