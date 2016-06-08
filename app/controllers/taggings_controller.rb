class TaggingsController < ApplicationController

	# FILTERS
	# ============================================================
	before_action :admin_restriction, only: [:edit, :update, :destroy]

	# PUBLIC METHODS
	# ============================================================
	# GET
	# ------------------------------------------------------------
	def index
		tags
	end

	def show
		tag
	end

	def edit
		tag
	end

	# PATCH/PUT
	# ------------------------------------------------------------
	def update
		tag

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
	# ------------------------------------------------------------
	def destroy
		tag

		@tag.destroy

		respond_to do |format|
			format.html { redirect_to(:action => 'index') }
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
		@tags       = Tag.order(:name).decorate
		@identities = Identity.sorted_alphabetic.decorate
		@relators   = Relator.order(:left_name).decorate
		@tag        = @tags.first
	end

end
