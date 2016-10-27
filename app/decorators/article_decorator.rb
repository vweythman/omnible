class ArticleDecorator < WorkDecorator
	
	# PUBLIC METHODS
	# ============================================================
	def all_crumbs
		[[h.t('collected.works'), h.works_path], [h.t('collected.nonfiction'), h.nonfiction_index_path], [h.t('content_types.articles'), h.articles_path]]
	end

	def klass
		:article
	end

end
