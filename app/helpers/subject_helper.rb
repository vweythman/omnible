module SubjectHelper

	def relationship_cells(character_id, relationships)
		cheading = 0
		cells    = ""
		links     = Array.new

		relationships.each do |relationship|
			recip, heading = find_inverse_relationship(relationship, character_id)

			if cheading == 0
				cheading = heading
			elsif cheading != heading
				cells    = "#{cells} #{build_row(cheading, links)}"
				cheading = heading	
				links    = Array.new()			
			end
			links.push link_to(recip.name, recip)
		end
		"#{cells} #{build_row(cheading, links)}".html_safe
	end

	def find_inverse_relationship(relationship, character_id)
		if relationship.left_id == character_id
			[relationship.right, relationship.relator.right_heading]
		else
			[relationship.left, relationship.relator.left_heading]
		end
	end

	def build_row(heading, links)
		th = content_tag :th do heading.pluralize(links.length) end
		td = content_tag :td do links.join(", ").html_safe end

		content_tag :tr do
			concat th
			concat td
		end
	end
	
end
