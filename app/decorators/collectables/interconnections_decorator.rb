module Collectables
	class InterconnectionsDecorator < Draper::CollectionDecorator

		# PUBLIC METHODS
		# ============================================================
		attr_accessor :person

		# PUBLIC METHODS
		# ============================================================
		def organize
			Interconnection.organize(object, person)
		end

		def rows
			self.organize.map do |type_name, group|
				title = type_name.titleize.pluralize(group)
				links = h.cslinks(group)
				yield(title, links)
			end
		end

		def collected_type
			"People"
		end

		def caption_heading
			"Relationships"
		end

		def table_type
			:facetable
		end

	end
end
