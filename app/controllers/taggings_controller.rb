class TaggingsController < ApplicationController

	# FILTERS
	# ============================================================
	before_action :can_view?,         only: [:edit, :update]
	before_action :tag,               only: [:show, :edit,   :update, :destroy]
	before_action :tags,              only: [:index]
	before_action :can_destroy?,      only: [:destroy]

	# PUBLIC METHODS
	# ============================================================
	# PATCH/PUT
	# ------------------------------------------------------------
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

	# POST
	# ------------------------------------------------------------
	def create
		@tag = Relator.new(tag_params)

		if @tag.save
			respond_to do |format|
				format.js   { tags }
				format.html { redirect_to @tag }
			end
		else
			render action: 'edit'
		end
	end

	# DELETE
	# ------------------------------------------------------------
	def destroy
		@tag.destroy
		respond_to do |format|
			format.html { redirect_to redirect_to(:action => 'index') }
			format.js   { tags }
			format.json { tags }
		end
	end

	# PRIVATE METHODS
	# ============================================================
	private

	# FIND
	# ------------------------------------------------------------
	# Tag :: find taggings
	def tag
		tags
	end

	# Tags :: find all
	def tags
		@activities = Activity.order(:name).decorate
		@tags       = Tag.order(:name).decorate
		@identities = Identity.sorted_alphabetic.decorate
		@relators   = Relator.order(:left_name).decorate
		@qualities  = Quality.order(:name).decorate
	end

	# PERMIT
	# ------------------------------------------------------------
	# RestrictedAccess :: editable by admin only
	def can_view?
		if !user_signed_in?
			redirect_to new_user_session_path
		elsif !current_user.admin?
			redirect_to dashboard_path
		end
	end

	def can_destroy?
		unless @tag.destroyable? current_user
			redirect_to @tag
		end
	end

end
