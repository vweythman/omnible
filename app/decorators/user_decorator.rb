class UserDecorator < Draper::Decorator
	delegate_all

	def uploadable_types
		[:article, :character, :item, :place, :story, :short_story]
	end

	def linkable_types
		[:story_link]
	end

	def uploaded_articles
		self.uploaded_works.articles
	end
	
	def uploaded_short_stories
		self.uploaded_works.short_stories
	end

	def uploaded_stories
		self.uploaded_works.stories
	end

end
