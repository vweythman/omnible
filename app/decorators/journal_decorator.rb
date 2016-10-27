class JournalDecorator < WorkDecorator
	
	# PUBLIC METHODS
	# ============================================================
	def all_crumbs
		[[h.t('collected.works'), h.works_path], [h.t('collected.nonfiction'), h.nonfiction_index_path], [h.t('content_types.journals'), h.journals_path]]
	end

	def current_articles
		@current_articles ||= Collectables::Works::JournalArticlesDecorator.decorate(built_articles)
	end

	def klass
		@klass ||= :journal
	end

	# PRIVATE METHODS
	# ============================================================
	private

	def built_articles
		self.articles.build if self.articles.length == 0
		self.articles
	end

end
