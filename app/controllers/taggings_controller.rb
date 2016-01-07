class TaggingsController < ApplicationController

	# OUTPUT FORMATS
	# ------------------------------------------------------------
	respond_to :html, :js

	# FILTERS
	# ------------------------------------------------------------
	before_action :admin_restrict, only: [:edit, :update]
	before_action :find_tag,       only: [:show, :edit, :update, :destroy]

	# PUBLIC METHODS
	# ------------------------------------------------------------
	# PATCH/PUT
	# ............................................................
	def update
		if @tag.update(tag_params)
			respond_to do |format|
				format.js
				format.html { redirect_to @tag }
			end
		else
			render action: 'edit'
		end
	end

	# DELETE
	# ............................................................
	def destroy
		if @tag.editable? current_user
			@tag.destroy
			redirect_to(:action => 'index')
		else
			redirect_to @tag
		end
	end

	# PRIVATE METHODS
	# ------------------------------------------------------------
	private

	def admin_restrict
		if !user_signed_in?
			redirect_to new_user_session_path
		elsif !current_user.admin?
			redirect_to dashboard_path
		end
	end

	def find_tag
		@activities = Activity.order(:name).decorate
		@tags       = Tag.order(:name).decorate
		@identities = Identity.sorted_alphabetic.decorate
		@relators   = Relator.order(:left_name).decorate
		@qualities  = Quality.order(:name).decorate
	end

end
