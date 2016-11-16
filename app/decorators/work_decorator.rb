# WorkFields
# ============================================================
# TABLE of CONTENTS
# ============================================================
# DELEGATION
# MODULES
# PUBLIC METHODS
# -- DISPLAY CONTENT BLOCKS
# ----- completion_status
# ----- max_rating_status
# ----- metadata_block
# ----- rated
# ----- skin_content
# ----- summarized
# ----- summary_block
#
# -- DISPLAY LINKS
# ----- createables
# ----- note_creation_link
# ----- note_insertion_link
#
# -- DISPLAY TOOLKIT BLOCKS
# ----- reader_response_bar
# ----- response_bar
#
# -- SELECT TEXT
# ----- creation_heading
# ----- klass
# ----- opinion_percentage - percent of likes vs dislikes
# ----- partial_prepend
# ----- summary_title
#
# PRIVATE METHODS
# -- LINKS :: WATCH AND KEEP TRACK OF
# ----- tracking_creation_link
# ----- tracking_deletion_link
#
# -- LINKS :: LIKE AND DISLIKE
# ----- dislike_creation_link
# ----- dislike_deletion_link
# ----- like_creation_link
# ----- like_deletion_link
#
# ============================================================

require 'organized_tag_groups'

class WorkDecorator < Draper::Decorator

	# ============================================================
	# DELEGATION
	# ============================================================
	delegate_all
	decorates_association :rating

	# ============================================================
	# MODULES
	# ============================================================
	include CreativeContent
	include CreativeContent::Composition
	include PageEditing
	include Widgets::Snippet
	include WorkFormFields
	include WorkTags

	# ============================================================
	# PUBLIC METHODS
	# ============================================================
	# ------------------------------------------------------------
	# DISPLAY CONTENT BLOCKS
	# ------------------------------------------------------------
	def category_block
		h.content_tag :div, class: 'category-data' do
			h.metadata(icon + " " + categorized_type, '')
		end
	end

	def completion_status
		h.content_tag :p, class: "status completion-status " + state_status.downcase do
			state_status
		end
	end

	def max_rating_status
		h.metadata("Max Rating:", rating.max_rating_value) if self.rating.present?
	end

	def metadata_block
		h.content_tag :div, class: 'metadata' do
			creatorships.includes(:category, :creator).each do |byline_value|
				h.concat h.metadata(byline_value.category.agentive_title + ":", h.link_to(byline_value.creator.name, h.pen_name_path(byline_value.creator.id)))
			end
			if has_likes?
				h.concat h.metadata("Likes:", self.opinion_percentage)
			end

 			h.concat max_rating_status
		end
	end

	def rated
		h.content_tag :p, class: 'ratings' do
			rating.full_list
		end unless rating.nil?
	end

	def skin_content
		if has_skin?
			h.render 'works/shared/skin', work: self
		end
	end

	def summarized
		h.content_tag :div, class: 'summary' do
			h.markdown object.summarized 
		end
	end

	def summary_block
		h.widget_cell(summary_title, class: 'summary-cell') do
			h.concat h.markdown(self.summarized)
		end
	end

	# ------------------------------------------------------------
	# DISPLAY LINKS
	# ------------------------------------------------------------
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

	# ------------------------------------------------------------
	# DISPLAY TOOLKIT BLOCKS
	# ------------------------------------------------------------
	def reader_response_bar
		current_user   = h.current_user
		response_paths = {}
		checked_status = {}

		if trackable?
			if current_user.tracking? object
				response_paths[:track], checked_status[:track] = tracking_deletion_link
			else
				response_paths[:track], checked_status[:track] = tracking_creation_link
			end
		end

		opinion = current_user.work_opinions.by_work(self).first

		if opinion.nil?
			response_paths[:like],    checked_status[:like]    = like_creation_link
			response_paths[:dislike], checked_status[:dislike] = dislike_creation_link
		elsif opinion.is_a_like?
			response_paths[:like],    checked_status[:like]    = like_deletion_link
			response_paths[:dislike], checked_status[:dislike] = dislike_creation_link
		else
			response_paths[:like],    checked_status[:like]    = like_creation_link
			response_paths[:dislike], checked_status[:dislike] = dislike_deletion_link
		end

		h.response_kit response_paths, checked_status
	end

	# ------------------------------------------------------------
	# SELECT TEXT
	# ------------------------------------------------------------
	def creation_heading
		h.capture do 
			h.concat icon
			h.concat " " + h.t("content_types.#{content_category}").singularize
		end
	end

	def opinion_percentage
		h.number_to_percentage(object.average_likes * 100, precision: 0)
	end

	def partial_prepend
		'works/' + klass.to_s.pluralize + '/'
	end

	def summary_title
		h.t("work.summary_title")
	end

	# ------------------------------------------------------------
	# QUESTIONS
	# ------------------------------------------------------------
	# being_read_nonanon? - reader is logged in
	# ............................................................
	def being_read_nonanon?
		h.current_user.present? && !(["Record", "WorkLink"].include? type)
	end

	# ============================================================
	# PRIVATE METHODS
	# ============================================================
	private

	# ------------------------------------------------------------
	# LINKS :: WATCH AND KEEP TRACK OF
	# ------------------------------------------------------------
	# tracking_creation_link - track if not already
	# ............................................................
	def tracking_creation_link
		[h.work_track_path(object), false]
	end

	# tracking_deletion_link - stop tracking if currently tracking
	# ............................................................
	def tracking_deletion_link
		[h.work_untrack_path(object), true]
	end

	# ------------------------------------------------------------
	# LINKS :: LIKE AND DISLIKE
	# ------------------------------------------------------------
	# dislike_creation_link - dislike if not already
	# ............................................................
	def dislike_creation_link
		[h.work_dislike_path(object), false]
	end

	# dislike_deletion_link - stop disliking
	# ............................................................
	def dislike_deletion_link
		[h.work_undislike_path(object), true]
	end

	# like_creation_link - like if not already
	# ............................................................
	def like_creation_link
		[h.work_like_path(object), false]
	end

	# like_deletion_link - stop liking
	# ............................................................
	def like_deletion_link
		[h.work_unlike_path(object), true]
	end

end
