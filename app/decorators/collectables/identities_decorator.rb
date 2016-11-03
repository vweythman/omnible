module Collectables
	class IdentitiesDecorator < Draper::CollectionDecorator

		# MODULES
		# ------------------------------------------------------------
		include DisabledCreation
		include ListableCollection
		include NestedFields
		include Widgets::Definitions

		# PUBLIC METHODS
		# ------------------------------------------------------------
		# -- About
		# ............................................................
		def heading
			"Character Descriptors"
		end

		def index_heading
			"Character Tags"
		end

		def nest_class
			"nested-tags-fieldset nested-#{klass}-fieldset nested-#{owner_klass}-fields"
		end

		def organized
			keys = self.facets.pluck(:id, :name).to_h
			results = {}
			self.each do |item|
				key = keys[item.facet_id]
				if results[key].nil?
					results[key] = []
				end
				results[key] << item
			end
			results
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
					h.concat h.tag_field_cell(["character", "describers", facet], list.nil? ? [] : list.map{|i| i.name }, facet.pluralize) 
				end
			end
		end

		# -- Related
		# ............................................................
		def facets
			@facets ||= Facet.all.order(:name)
		end

		# PRIVATE METHODS
		# ------------------------------------------------------------
		private

		def list_possible


			list = Hash[self.facets.pluck(:name).zip(Array.new())]
			if self.length > 0
				ordered = self.organized
				list.merge(ordered)
			else
				list
			end
		end


	end
end
