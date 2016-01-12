class InterconnectionsDecorator < Draper::CollectionDecorator

	# MODULES
	# ------------------------------------------------------------
	include TableableCollection

	# PUBLIC METHODS
	# ------------------------------------------------------------
	def faceted_table(parent)
		@visitor = parent
		tableize
	end

	def organize
		Interconnection.organize(object, visitor)
	end

	def rows
		@rows ||= self.organize
	end

	def visitor
		@visitor ||= nil
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
