class LikesController < ApplicationController

	# CALLBACKS
	# ============================================================
	before_action :signed_restriction

	# MODULES
	# ============================================================
	include ReaderResponse

	# PUBLIC METHODS
	# ============================================================
	# GET
	# ------------------------------------------------------------
	def index
		if params[:is_reader]
			@results_type = 'user-results'
			@user  = User.find(params[:user_id])
			@likes = Collectables::FavoritesDecorator.decorate @user.liked_works
		else
			@results_type = 'dashboard-body'
			@likes = Collectables::Dashboard::FavoritesDecorator.decorate current_user.liked_works
		end
	end

	# POST
	# ------------------------------------------------------------
	def create
		work
		opinion

		if @opinion.nil?
			WorkOpinion.create(user_id: current_user.id, work_id: @work.id, value: 1)
		else
			@opinion.make_liked
			@opinion.save
			response_format
		end
	end

	# DELETE
	# ------------------------------------------------------------
	def destroy
		work
		opinion

		if !@opinion.nil? && @opinion.is_a_like?
			@opinion.destroy
			response_format
		end
	end

end
