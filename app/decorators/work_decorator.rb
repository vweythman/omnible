class WorkDecorator < Draper::Decorator

	# DELEGATION
	# ------------------------------------------------------------
	delegate_all
	decorates_association :rating

	# MODULES
	# ------------------------------------------------------------
	include Agented
	include PageEditing
	include Timestamped
	include Titleizeable

	# PUBLIC METHODS
	# ------------------------------------------------------------
	# -- About
	# ............................................................
	def klass
		:work
	end

	def summary
		object.summary || ""
	end

	def summarized
		h.content_tag :div, class: 'summary' do
			h.markdown self.summary 
		end unless self.summary.empty?
	end

	# -- Creating & Editing
	# ............................................................
	def creation_title
		"Create Work"
	end

	def editor_heading
		h.content_tag :h1 do "Edit" end
	end

	# -- Status
	# ............................................................
	def snippet_path
		'shared/snippets/' + klass.to_s
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

	def has_skin?
		self.skin.present? 
	end

	# -- Tags
	# ............................................................
	def all_tags
		(self.tags + self.characters + self.places).sort_by! { |x| x[:name].downcase }
	end

	def all_tags_line
		h.content_tag :p, class: 'tags' do h.cslinks self.all_tags end
	end

	def main_tags
		(self.tags + self.main_characters + self.places).sort_by! { |x| x[:name].downcase }
	end

	def snippet_tags_line
		t = self.main_tags
		
		if t.length > 0
			h.content_tag :p, class: 'tags' do h.cslinks t end
		end
	end

	def tag_names
		self.tags.map(&:name)
	end

	# -- Related
	# ............................................................
	def important_characters
		work.narrative? ? self.main_characters : self.people_subjects
	end

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

	# -- Notes
	# ............................................................
	def note_creation_link
		if self.editable?(h.current_user)
			h.prechecked_creation_toolkit("Note", [self, :note])
		end
	end

	def note_insertion_link
		if self.editable?(h.current_user)
			h.insertion_toolkit("Note", [self, :note])
		end
	end

	# -- Places
	# ............................................................
	def location_heading
		self.narrative? ? "Settings" : "Subject (Location)"
	end

	def place_names
		self.places.map(&:name)
	end

end
