class ArtDecorator < WorkDecorator
	
	# PUBLIC METHODS
	# ============================================================
	def all_crumbs
		[[h.t('collected.works'), h.works_path], [h.t('content_types.art'), h.poems_path]]
	end

	def meta_fields
		"works/shared/fields/viewable_meta_fields"
	end

	def summary_title
		h.t("art.summary_title")
	end

	def title_for_creation
		"Upload Art"
	end

end
