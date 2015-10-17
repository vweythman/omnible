class InterconnectionsDecorator < Draper::CollectionDecorator

	def organize(parent)
		Interconnection.organize(object, parent)
	end

	def rows(parent)
		rows = self.organize(parent)
		h.content_tag :tbody do
			rows.each do |relator_name, characters|
				h.concat row(relator_name.titleize.pluralize(characters), characters)
			end
		end
	end

	def row(heading, group)
		th = h.content_tag :th do heading end
		td = h.content_tag :td do h.cslinks(group) end
		
		h.content_tag :tr do
			th + td
		end
	end
end
