class ArticleDecorator < WorkDecorator
	
	# PUBLIC METHODS
	# ============================================================
	def klass
		:article
	end

	def breadcrumbs
		crumbs = [[h.t('collected.works'), h.works_path], [h.t('collected.nonfiction'), h.nonfiction_index_path], [h.t('content_types.articles'), h.articles_path]]
		breacrumbing(crumbs)
	end

end
