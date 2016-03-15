class WorkDecorator < Draper::Decorator

	# DELEGATION
	# ============================================================
	delegate_all
	decorates_association :rating

	# MODULE
	# ============================================================
	include CreativeContent
	include CreativeContent::Composition
	include PageEditing
	include Widgets::Snippet

	# PUBLIC METHODS
	# ============================================================
	# WORK
	# ------------------------------------------------------------
	# SET
	# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	def summary
		object.summary || ""
	end

	def klass
		:work
	end

	# CHECK
	# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	def has_skin?
		self.skin.present?
	end

	def skin_content
		if has_skin?
			h.render 'works/shared/skin', work: self
		end
	end

	# RENDER
	# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	def completion_status
		h.content_tag :p, class: "status completion-status " + status_label.downcase do
			status_label
		end
	end

	def rated
		h.content_tag :p, class: 'ratings' do
			rating.full_list
		end
	end

	def summarized
		h.content_tag :div, class: 'summary' do
			h.markdown self.summary 
		end unless self.summary.empty?
	end

	# TAGS
	# ------------------------------------------------------------
	# GET
	# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	def all_tags
		@all_tags  ||= (self.tags + self.characters + self.places + self.works).sort_by! { |x| x.heading.downcase }
	end

	def cohorted_characters
		@cohorted_characters ||= Appearance.organize(self.appearances)
	end

	def organized_works
		@organized_works ||= WorkConnection.organize(self.tagged_connections)
	end

	def cohort_names_by(role)
		character_group = cohorted_characters.with_indifferent_access[role]

		character_group.nil? ? [] : character_group.map(&:name)
	end

	def organized_work_titles_by(group)
		grouped_works = organized_works.with_indifferent_access[group]

		grouped_works.nil? ? [] : grouped_works.map(&:title)
	end

	def main_tags
		@main_tags ||= (self.tags + self.important_characters + self.places).sort_by! { |x| x[:name].downcase }
	end

	# SET
	# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	def important_characters
		@important_characters ||= work.narrative? ? self.main_characters : self.people_subjects
	end

	def location_heading
		self.narrative? ? "Settings" : "Subject (Location)"
	end

	# RENDER
	# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	def all_tags_line
		h.content_tag :p, class: 'tags' do h.cslinks self.all_tags end
	end

	def snippet_tags_line
		if main_tags.length > 0
			h.content_tag :p, class: 'tags' do h.cslinks main_tags end
		end
	end

	# NOTES
	# ------------------------------------------------------------
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

	# FORM
	# ------------------------------------------------------------
	# GET
	# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	def chooseable_skins
		uploader.skins
	end

	# SET
	# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	def primary_fields
		"works/shared/fields"
	end

	def tag_fields
		"works/shared/tag_fields"
	end

	# CHECK
	# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	def can_skin?
		!self.record?
	end

end