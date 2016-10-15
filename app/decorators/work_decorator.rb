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
	include WorkFormFields

	# PUBLIC METHODS
	# ============================================================
	# GETTERS
	# ------------------------------------------------------------
	# Variables
	# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	def klass
		@klass ||= :work
	end

	def opinion_percentage
		h.number_to_percentage(object.average_likes * 100, precision: 0)
	end

	# Links : Creation
	# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	def createables
		if self.editable?(h.current_user)
			h.prechecked_createables [[self, :note]]
		end
	end

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

	def work_tracking
		[h.work_track_path(object), false]
	end

	def work_like_link
		[h.work_like_path(object), false]
	end

	def work_dislike_link
		[h.work_dislike_path(object), false]
	end

	# Links :: Deletion
	# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	def work_undislike_link
		[h.work_undislike_path(object), true]
	end

	def work_unlike_link
		[h.work_unlike_path(object), true]
	end

	def work_untracking
		[h.work_untrack_path(object), true]
	end

	# Tags :: Sliced
	# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	def main_tags
		@main_tags ||= (self.tags + self.important_characters + self.places).sort_by! { |x| x[:name].downcase }
	end

	def important_characters
		@important_characters ||= work.narrative? ? Array(snippet_ordered_characters.group_by("main")) : Array(snippet_ordered_characters.group_by("subject"))
	end
	
	# Tags :: Sorted
	# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	def ordered_characters
		@ordered_characters ||= order_tags Appearance.organize(self.appearances.with_character)
	end

	def snippet_ordered_characters
		@ordered_characters ||= order_tags Appearance.organize(self.appearances)
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

	# VIEWS
	# ------------------------------------------------------------
	# Content Blocks
	# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	def metadata_block
		h.content_tag :div, class: 'metadata' do
			creatorships.includes(:category, :creator).each do |byline_value|
				h.concat h.metadata(byline_value.category.agentive_title + ":", h.link_to(byline_value.creator.name, h.pen_name_path(byline_value.creator.id)))
			end
			if has_likes?
				h.concat h.metadata("Likes:", self.opinion_percentage)
			end
 			if self.rating.present?
 				h.concat h.metadata("Max Rating:", rating.max_rating_value)
			end
		end
	end

	def reader_response_bar
		current_user   = h.current_user
		response_paths = {}
		checked_status = {}

		if trackable?
			if current_user.tracking? object
				response_paths[:track], checked_status[:track] = work_untracking
			else
				response_paths[:track], checked_status[:track] = work_tracking
			end
		end

		opinion = current_user.work_opinions.by_work(self).first

		if opinion.nil?
			response_paths[:like],    checked_status[:like]    = work_like_link
			response_paths[:dislike], checked_status[:dislike] = work_dislike_link
		elsif opinion.is_a_like?
			response_paths[:like],    checked_status[:like]    = work_unlike_link
			response_paths[:dislike], checked_status[:dislike] = work_dislike_link
		else
			response_paths[:like],    checked_status[:like]    = work_like_link
			response_paths[:dislike], checked_status[:dislike] = work_undislike_link
		end
		h.response_kit response_paths, checked_status
	end

	def response_bar
		if self.uploader? h.current_user
			edit_bar
		elsif h.current_user.present? && !(["Record", "WorkLink"].include? type)
			reader_response_bar
		end
	end

	def summary_block
		h.widget_cell(summary_title, class: 'summary-cell') do
			h.concat h.markdown(self.summarized)
		end
	end

	def summary_title
		h.t("work.summary_title")
	end

	# Content Tags
	# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	def all_tags_line
		h.tag_group all_tags, 'works', { class: 'all-tags tags' }, { class: 'tag' }
	end

	def completion_status
		h.content_tag :p, class: "status completion-status " + status_label.downcase do
			status_label
		end
	end

	def rated
		h.content_tag :p, class: 'ratings' do
			rating.full_list
		end unless rating.nil?
	end

	def snippet_tags_line
		if main_tags.length > 0
			h.tag_group main_tags, 'works', { class: 'main-tags tags' }, { class: 'tag' }
		end
	end

	def summarized
		h.content_tag :div, class: 'summary' do
			h.markdown object.summarized 
		end
	end

	# Partial Locations
	# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	def partial_prepend
		'works/' + klass.to_s.pluralize + '/'
	end

	def skin_content
		if has_skin?
			h.render 'works/shared/skin', work: self
		end
	end

	# PRIVATE METHODS
	# ============================================================
	private

	def order_tags(tags)
		OrganizedTagGroups.new tags
	end

end
