class DislikesController < ApplicationController

	before_action :signed_restriction

	def create
		work
		opinion
		if @opinion.nil?
			WorkOpinion.create(user_id: current_user.id, work_id: @work.id, value: -1)
		else
			@opinion.make_disliked
			@opinion.save
			respond_to do |format|
				format.js { render layout: false }
			end
		end
	end

	def destroy
		work
		opinion
		if !@opinion.nil? && @opinion.is_a_dislike?
			@opinion.destroy
			respond_to do |format|
				format.js { render layout: false }
			end
		end
	end

	def work
		@work = Work.find(params[:work_id]).decorate
	end

	def opinion
		@opinion = current_user.work_opinions.by_work(@work).first
	end

end
