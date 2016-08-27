require 'organized_tag_groups'

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
		@klass ||= :work
	end

	def partial_prepend
		'works/' + klass.to_s.pluralize + '/'
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

	def response_bar
		if self.uploader? h.current_user
			edit_bar
		elsif !(["Record", "WorkLink"].include? type)
			reader_response_bar
		end
	end

	def reader_response_bar
		current_user   = h.current_user
		response_paths = {}
		checked_status = {}

		unless complete?
			logger.debug "!!!!! #{complete?}"
			if current_user.tracking? object
				response_paths[:watch], checked_status[:watch] = work_untracking
			else
				response_paths[:watch], checked_status[:watch] = work_tracking
			end
		end

		opinion = current_user.work_opinions.by_work(self).first

		if opinion.nil?
			response_paths[:like],    checked_status[:like]    = work_liking
			response_paths[:dislike], checked_status[:dislike] = work_disliking
		elsif opinion.is_a_like?
			response_paths[:like],    checked_status[:like]    = work_unliking
			response_paths[:dislike], checked_status[:dislike] = work_disliking
		else
			response_paths[:like],    checked_status[:like]    = work_liking
			response_paths[:dislike], checked_status[:dislike] = work_undisliking
		end
		h.response_kit response_paths, checked_status
	end

	# ADD
	def work_tracking
		[h.work_track_path(object), false]
	end

	def work_liking
		[h.work_like_path(object), false]
	end

	def work_disliking
		[h.work_track_path(object), false]
	end

	# REMOVE
	def work_undisliking
		[h.work_undislike_path(object), true]
	end

	def work_unliking
		[h.work_unliking(object), true]
	end

	def work_untracking
		[h.work_untrack_path(object), true]
	end

	# TAGS
	# ------------------------------------------------------------
	# GET Collected Tags
	# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	def all_tags
		@all_tags  ||= (self.tags + self.characters + self.places + self.works).sort_by! { |x| x.heading.downcase }
	end

	def main_tags
		@main_tags ||= (self.tags + self.important_characters + self.places).sort_by! { |x| x[:name].downcase }
	end

	# GET :: Ordered Tags
	# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	def ordered_characters
		@ordered_characters ||= order_tags Appearance.organize(self.appearances.with_character)
	end

	def ordered_squads
		@social_cohorts     ||= order_tags SocialAppearance.organize(self.social_appearances.with_squad)
	end

	def ordered_true_tags
		@ordered_true_tags  ||= order_tags Tagging.organize(self.taggings.with_tag)
	end

	def ordered_works
		@ordered_works      ||= order_tags WorkConnection.organize(self.intratagged.with_tagged)
	end

	# SET
	# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	def important_characters
		@important_characters ||= work.narrative? ? Array(ordered_characters.group_by("main")) : Array(ordered_characters.group_by("subject"))
	end

	def location_heading
		self.narrative? ? "Settings" : "Subject (Location)"
	end

	# RENDER
	# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	def all_tags_line
		h.tag_group all_tags, 'works', { class: 'all-tags tags' }, { class: 'tag' }
	end

	def snippet_tags_line
		if main_tags.length > 0
			h.tag_group main_tags, 'works', { class: 'main-tags tags' }, { class: 'tag' }
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
	def creatorship_fields
		self.record? ? 'works/shared/fields/creatorship_fields' : 'works/shared/fields/creatorship_local_fields'
	end

	def meta_fields
		"works/shared/fields/meta_fields"
	end

	def tag_fields
		"works/shared/fields/tag_fields"
	end

	# CHECK
	# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	def can_skin?
		!self.record?
	end

	private

	# PUBLIC METHODS
	# ============================================================
	def order_tags(tags)
		OrganizedTagGroups.new tags
	end

end
