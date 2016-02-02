class PlaceDecorator < Draper::Decorator

	# DELEGATION
	# ------------------------------------------------------------
	delegate_all

	# MODULES
	# ------------------------------------------------------------
	include CreativeContent
	include CreativeContent::Dossier
	include PageEditing

	# PUBLIC METHODS
	# ------------------------------------------------------------
	# -- About
	# ............................................................
	def realness_choices
		["Actual Place", "Fictitious Place"]
	end

	# -- Creating & Editing
	# ............................................................
	def creation_title
		"Create Place"
	end

	def editor_heading
		h.content_tag :h1 do "Edit" end
	end
	
	def editing_title
		name + " (Edit Draft)"
	end

	# -- Lists
	# ............................................................
	def list_characters
		related_models("Tagged By", "taggers", self.characters.decorate)
	end 

	def list_domains
		related_places("Contained Within", object.domains.includes(:form))
	end

	def list_subdomains
		related_places("Contains", object.subdomains.includes(:form))
	end

	def list_works
		related_models("Setting/Subject of", "taggers", self.works.decorate)
	end

	# PRIVATE METHODS
	# ------------------------------------------------------------
	private

	def related_places(title, places)
		related_models(title, "places", PlacesDecorator.decorate(places))
	end

	def related_models(title, relator, models)
		if models.length > 0
			h.content_tag :div, class: "related-#{relator}" do
				h.subgrouped_list title, models
			end
		end
	end

end
