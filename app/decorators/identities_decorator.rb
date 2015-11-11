class IdentitiesDecorator < Draper::CollectionDecorator

	# HEADINGS AND IDENTIFICATION
	# ------------------------------------------------------------
	def heading
		"Character Descriptors"
	end

	def formid
		"form_identities"
	end

	# ABOUT
	# ------------------------------------------------------------
	def can_list?
		self.length > 0
	end

	def klass
		:identities
	end

	def list
		h.render partial: "shared/lists/definitions", object: self.organized
	end

	def list_possible
		list = Hash[self.facets.pluck(:name).zip(Array.new())]
		if self.length > 0
			ordered = self.organized
			list.merge(ordered)
		else
			list
		end
	end

	def organized
		Identity.organize(object)
	end

	def field_class
		"tags identities descriptions"
	end

	# RELATED MODELS
	# ------------------------------------------------------------
	def facets
		@facets ||= Facet.all.order(:name)
	end

end
