class ComicDecorator < WorkDecorator

	# PUBLIC METHODS
	# ============================================================
	# STRING OUTPUT
	# ------------------------------------------------------------
	def title_for_creation
		"Upload Comic"
	end

	def summary_title
		h.t("art.summary_title")
	end

	def meta_fields
		"works/shared/fields/viewable_meta_fields"
	end

	# SYMBOL OUTPUT
	# ------------------------------------------------------------
	def klass
		:comic
	end

	# LIST OUTPUT
	# ------------------------------------------------------------
	def all_crumbs
		[[h.t('collected.works'), h.works_path], [h.t('collected.fiction'), h.fiction_index_path], [h.t('content_types.comics'), h.comics_path]]
	end

	def current_pages
		@current_pages ||= Collectables::Works::ComicPagesDecorator.decorate(self.works)
	end

end
