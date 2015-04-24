module SubjectHelper

	def relationship_cells(character_id, relationships)
		reltype = 0
		cells   = ""

		relationships.each do |relationship|


			if relationship.left_id == character_id
				recip  = relationship.right
				rel_id = relationship.relator.right_heading.pluralize
			else
				recip = relationship.left
				rel_id = relationship.relator.left_heading.pluralize
			end

			if reltype == 0
				reltype = rel_id
				th      = content_tag :th do reltype end

				cells   = "#{cells}<tr>#{th}<td>"
			elsif reltype != rel_id
				reltype = rel_id
				th      = content_tag :th do reltype end

				cells   = "#{cells.chop}</td></tr><tr>#{th}<td>"				
			end

			cells = "#{cells} #{link_to(recip.name, recip)},"
		end

		"#{cells.chop}</tr>".html_safe
	end
	
end
