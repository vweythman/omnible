class DiscussionsController < ApplicationController

	# PUBLIC METHODS
	# ============================================================
	def show
		discussed

		if has_root?
			comments_thread
		else
			full_comments
		end
	end

	# PRIVATE METHODS
	# ============================================================
	private

	def discussed
		type   = request.path.split("/")[1].singularize.capitalize
		@topic = Topic.where(discussed_id: params[:id], discussed_type: type).first
		@discussed = @topic.discussed
	end

	def full_comments
		@comments = @discussed.comments.ordered.truncate_at(depth_control)
	end

	def comments_thread
		@comment  = @discussed.comments.find(params[:root])
		@comments = @comment.self_and_descendants.truncate_at(depth_control(@comment.depth))
	end

	def has_root?
		params[:root].present?
	end

	def depth_control(offset = 0)
		@depth_control = 7 + offset
	end

end
