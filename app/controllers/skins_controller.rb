class SkinsController < ApplicationController

	# FILTERS
	# ============================================================
	before_action :can_view?
	before_action :skins, only: [:index]
	before_action :skin,  only: [:show, :edit, :update, :destroy]

	# PUBLIC METHODS
	# ============================================================
	# GET
	# ------------------------------------------------------------
	def new
		@skin = Skin.new
	end

	# POST
	# ------------------------------------------------------------
	def create
		@skin = current_user.skins.new(skin_params).decorate

		respond_to do |format|
			if @skin.save
				format.html { redirect_to @skin,     notice: 'Stylesheet was successfully created.' }
				format.json { render action: 'show', status: :created, location: @skin }
			else
				format.html { render action: 'new' }
				format.json { render json: @skin.errors, status: :unprocessable_entity }
			end
		end
	end

	# PATCH/PUT
	# ------------------------------------------------------------
	def update
		respond_to do |format|
			if @skin.update(skin_params)
				format.html { redirect_to @skin, notice: 'Stylesheet was successfully updated.' }
				format.json { head :no_content }
			else
				format.html { render action: 'edit' }
				format.json { render json: @skin.errors, status: :unprocessable_entity }
			end
		end
	end

	# DELETE
	# ------------------------------------------------------------
	def destroy
		@skin.destroy
		respond_to do |format|
			format.html { redirect_to skins_url }
			format.json { head :no_content }
		end
	end

	# PRIVATE METHODS
	# ============================================================
	private

	def can_view?
		unless user_signed_in?
			redirect_to root_url
		end
	end

	def skin
		@skin = Skin.find(params[:id]).decorate
	end

	def skins
		@skins = Skin.general_use
	end

	def skin_params
		params.require(:skin).permit(:title, :style, :status)
	end

end