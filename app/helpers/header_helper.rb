module HeaderHelper
	# output header for "new" page
	def creation_header(heading)
		provide(:title, "Add #{strip_tags(heading)}")
		content_tag :h1 do
			"Add #{heading}".html_safe
		end
	end
	# OUTPUT header for "edit" page
	def edit_header(name, title)
		provide(:title, "Edit #{title}".html_safe)
		content_tag :h1 do
			"Edit #{name}"
		end
	end
end