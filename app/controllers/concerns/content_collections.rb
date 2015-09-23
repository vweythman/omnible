# Curated Methods
# ================================================================================

module ContentCollections
	
	def find_comments
		@comments = @work.comments
		@comment  = Comment.new

		@comment.topic = @work.topic
	end

	def find_chapter_comments
		@comments = @chapter.comments
		@comment  = Comment.new

		@comment.topic = @chapter.topic
	end

	def find_note_comments
		@comments = @note.comments
		@comment  = Comment.new

		@comment.topic = @note.topic
	end

	# setup form components
	def define_components
		@general_tags = @work.tags.pluck(:name)
		@characters   = @work.init_characters
	end

	def add_characters
		appearances = Character.batch Appearance.update_for(@work, params.slice(:main, :side, :mentioned)), current_user
		params[:work][:appearances_attributes] = appearances
	end

end
