class JournalDecorator < WorkDecorator

	def klass
		@klass ||= :journal
	end

	def current_articles
		@current_articles ||= Collectables::Works::JournalArticlesDecorator.decorate(built_articles)
	end

	def breadcrumbs
		crumbs = [[h.t('collected.works'), h.works_path], [h.t('collected.nonfiction'), h.nonfiction_index_path], [h.t('content_types.journals'), h.journals_path]]
		breacrumbing(crumbs)
	end

	private
	def built_articles
		self.articles.build if self.articles.length == 0
		self.articles
	end

end
