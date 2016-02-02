class IdentitiesDecorator < Draper::CollectionDecorator

	# MODULES
	# ------------------------------------------------------------
	include DisabledCreation
	include ListableCollection
	include NestedFields

	# PUBLIC METHODS
	# ------------------------------------------------------------
	# -- About
	# ............................................................
	def heading
		"Character Descriptors"
	end

	def index_heading
		"Character Tags (Identities)"
	end

	def klass
		:identities
	end

	def organized
		Identity.organize(object)
	end

	def show_heading
		"Descriptors"
	end

	# -- Lists
	# ............................................................
	def can_list?
		self.length > 0
	end

	# -- NestedFields
	# ............................................................
	def fields
		h.capture do
			list_possible.each do |facet, list|
				h.concat h.taggables(["character", "describers", facet], list.nil? ? [] : list.map{|i| i.name }, facet.pluralize) 
			end
		end
	end

	def nest_class
		"tags identities descriptions"
	end

	# -- Related
	# ............................................................
	def facets
		@facets ||= Facet.all.order(:name)
	end

	# PRIVATE METHODS
	# ------------------------------------------------------------
	private

	def listable
		self.organized
	end

	def list_type
		:definitions
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

	def results_content_type
		:titled_cell
	end

end
