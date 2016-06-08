class CommentsController < ApplicationController

	# PUBLIC METHODS
	# ============================================================
	# GET
	# ------------------------------------------------------------
	def index
	end

	def show
	end

	def new
		commented_comment
		@comment = Comment.new
		@comment.topic_id = @commented_comment.topic_id
		@comment.parent   = @commented_comment
	end

	def edit
	end

	# POST
	# ------------------------------------------------------------
	def create
		form_topic
		unless current_user.blocked_by? @topic.creator
			@comment = Comment.create!(comment_params)

			if comment_needs_parent?
				@comment.move_to_child_of parent_comment
			end

			@comment.reload

			redirect_to [@topic.discussed, "discussion"]
		end
	end

	# DELETE
	# ------------------------------------------------------------
	def destroy
	end

	# PRIVATE METHODS
	# ============================================================
	private

	def comment_params
		permitted = params.require(:comment).permit(:content, :topic_id)
		permitted.merge(:creator_id => current_user.id, :creator_type => "User")
	end

	def commented_comment
		@commented_comment = Comment.find(params[:id])
	end

	# find by id
	def parent_comment
		@parent_comment = Comment.find(params[:comment][:parent_id])
	end

	def form_topic
		@topic = Topic.find(params[:comment][:topic_id])
	end

	def comment_needs_parent?
		params[:comment][:parent_id] != ""
	end
end
