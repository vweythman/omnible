class ArtDecorator < WorkDecorator
	
	# PUBLIC METHODS
	# ============================================================
	def klass
		:art
	end

	def icon_choice
		'image'
	end

	def title_for_creation
		"Upload Art"
	end

	def meta_fields
		"works/shared/fields/viewable_meta_fields"
	end

	def summary_title
		h.t("art.summary_title")
	end

	def breadcrumbs
		crumbs = [["Works", h.works_path], ["Art", h.artwork_path]]
		breacrumbing(crumbs)
	end

end
