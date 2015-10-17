class WorkDecorator < EditableDecorator

	delegate_all
	decorates_association :rating

	# HEADINGS AND IDENTIFICATION
	# ------------------------------------------------------------
	def creation_title
		"Create Work"
	end

	def editing_title
		title + " (Edit Draft)"
	end

	def editor_heading
		h.content_tag :h1 do "Edit" end
	end

	# ABOUT
	# ------------------------------------------------------------
	def summary
		object.summary || ""
	end

	def rated
		h.content_tag :p, class: 'ratings' do
			rating.full_list
		end
	end

	def completion_status
		state = complete? ? "Complete" : "Incomplete"
		h.content_tag :p, class: "status " + state.downcase do
			state
		end
	end

	# RELATED MODELS
	# ------------------------------------------------------------
	def character_form_list()
		@all_characters ||= Appearance.organize(self.appearances)
	end

	def cohort_names_by(role)
		all_characters = character_form_list.with_indifferent_access
		character_group = all_characters[role]
		character_group.nil? ? [] : character_group.map(&:name)
	end

	def cohort_heading_by(role)
		cheading = self.narrative? ? role + " Characters" : role + " (People)"
		cheading.titleize
	end

	def location_heading
		self.narrative? ? "Settings" : "Subject (Location)"
	end

	def tag_names
		self.tags.map(&:name)
	end

	def place_names
		self.places.map(&:name)
	end
	
end
