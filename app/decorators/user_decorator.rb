class UserDecorator < Draper::Decorator
	
	# DELEGATION
	# ------------------------------------------------------------
	delegate_all

	# PUBLIC METHODS
	# ------------------------------------------------------------
	def uploadable_types
		[:article, :character, :item, :place, :story, :short_story]
	end

	def linkable_types
		[:story_link]
	end

	def uploaded_articles
		@uploaded_articles ||= ArticlesDecorator.decorate self.uploaded_works.articles
	end
	
	def uploaded_short_stories
		@uploaded_short_stories ||= ShortStoriesDecorator.decorate self.uploaded_works.short_stories
	end

	def uploaded_stories
		@uploaded_stories ||= StoriesDecorator.decorate self.uploaded_works.stories
	end

end
