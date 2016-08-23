class JournalDecorator < WorkDecorator

	def klass
		@klass ||= :journal
	end

	def current_articles
		@current_articles ||= Collectables::JournalArticlesDecorator.decorate(built_articles)
	end

	private
	def built_articles
		self.articles.build if self.articles.length == 0
		self.articles
	end

end
