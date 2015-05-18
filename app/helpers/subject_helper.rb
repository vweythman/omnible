module SubjectHelper

	def connection_cells(character_id, connections)
		cheading = 0
		cells    = ""
		links     = Array.new

		connections.each do |connection|
			recip, heading = find_inverse_connection(connection, character_id)

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

	def find_inverse_connection(connection, character_id)
		if connection.left_id == character_id
			[connection.right, connection.relator.right_heading]
		else
			[connection.left, connection.relator.left_heading]
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
