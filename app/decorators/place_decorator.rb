class PlaceDecorator < EditableDecorator
	delegate_all

	def realness_choices
		["Actual Place", "Fictitious Place"]
	end

	def editing_title
		name + " (Edit Draft)"
	end

	def editor_heading
		h.content_tag :h1 do "Edit" end
	end

	def creation_title
		"Create Place"
	end

	def list_domains
		related_places("Contained Within", object.domains.includes(:form))
	end

	def list_subdomains
		related_places("Contains", object.subdomains.includes(:form))
	end

	private 
	def related_places(title, places)
		h2   = h.content_tag :h2 do title end
		list = h.render partial: "shared/definitions", object: Place.organize(places)

		if object.subdomains.length > 0
			h.content_tag :div, class: "related-places" do
				(h2 + list).html_safe
			end
		end
	end
end
