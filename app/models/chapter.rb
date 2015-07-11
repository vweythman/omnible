# Chapter
# ================================================================================
# chapter is a subpart of stories
#
# Variables (max length: 15 characters) 
# --------------------------------------------------------------------------------
#  variable name   | type        | about
# --------------------------------------------------------------------------------
#  id              | integer     | unique
#  title           | string      | maximum of 250 characters
#  content         | text        | cannot be null
#  story_id        | integer     | cannot be null
#  about           | text        | can be null
#  afterward       | text        | can be null
#  position        | integer     | default = 1
#  created_at      | datetime    | must be earlier or equal to updated_at
#  updated_at      | datetime    | must be later or equal to created_at
#
# Methods (max length: 25 characters) 
# --------------------------------------------------------------------------------
#  method name                 | output type | description
# --------------------------------------------------------------------------------
#  heading                     | string      | defines the main means of
#                              |             | addressing the model
#  complete_heading            | string      | defines the full chapter heading
#  word_count                  | integer     | count the number of words in the 
#                              |             | chapter contents
#  prev                        | object      | finds the previous chapter
#  next                        | object      | finds the next chapter
#  editable                    | bool        | user is allowed to edit
# ================================================================================

class Chapter < ActiveRecord::Base

	# VALIDATIONS
	# ------------------------------------------------------------
	validates :story_id, presence: true
	validates :content, presence: true
	validates_uniqueness_of :position, :scope => :story_id

	# MODULES
	# ------------------------------------------------------------
	include Discussable

	# CALLBACKS
	# ------------------------------------------------------------
	after_create :set_discussion
	before_create :set_position

	# SCOPES
	# ------------------------------------------------------------
	default_scope { order('chapters.position asc') }
	scope :prev_in_story, ->(story_id, position) { where("story_id = ? AND position < ?", story_id, position) }
	scope :next_in_story, ->(story_id, position) { where("story_id = ? AND position > ?", story_id, position) }

	# ASSOCIATIONS
	# ------------------------------------------------------------
	belongs_to :story,    :inverse_of => :chapters, class_name: "Work"
	has_one    :topic,    :inverse_of => :discussed, as: :discussed
	has_many   :comments, :through => :discussion, as: :discussed

	delegate :user, to: :story

	# METHODS
	# ------------------------------------------------------------
	# Heading
	# - defines the main means of addressing the model
	def heading
		if title.blank?
			"Chapter #{self.position}"
		else
			title
		end
	end

	# CompleteHeading
	# - defines the full chapter heading
	def complete_heading
		current_title = "Chapter #{self.position}"
		current_title.concat " - #{self.title}" unless title.blank?
		current_title
	end

	# Prev
	# - finds the previous chapter
	def prev
		@prev ||= Chapter.prev_in_story(self.story_id, self.position).first
	end

	# Next
	# - finds the next chapter
	def next
		@next ||= Chapter.next_in_story(self.story_id, self.position).first
	end

	# WordCount
	# - count the number of words in the chapter contents
	def word_count
		body = self.content.downcase.gsub(/[^[:word:]\s]/, '')
		I18n.transliterate(body).scan(/[a-zA-Z]+/).size
	end

	# MakeRoomAfter
	# - create space for a chapter after this chapter
	def make_room
		self.position ||= 0
		success = false
		Chapter.transaction do
			success = Chapter.where("story_id = ? AND position > ?", self.story_id, self.position).update_all("position = -1 * (position + 1)")
			success = success && Chapter.where("story_id = ? AND position < 0", self.story_id).update_all("position = -1 * position")
		end
		return success
	end

	# PlaceFirst
	# - place as first chapter
	def place_first
		if self.story.newest_chapter_position == 1
			self.position = 1
		else
			self.make_room
			self.position = 1
		end
	end

	# PlaceAfter
	# - set after previous chapter
	def place_after(prev, made_room = false)
		if self.story != prev.story
			return false
		end

		last_position = self.story.newest_chapter_position
		next_position = prev.position + 1

		if !(made_room || last_position == next_position)
			prev.make_room
		end

		self.position = next_position
	end

	# Editable
	# - user is allowed to edit
	def editable?(user)
		self.user.id == user.id
	end

	# CLASS METHODS
	# SwapPositions
	# - swap the positions of two chapters of the same story
	def self.swap_positions(left, right)
		if left.story != right.story
			return false
		end

		temp_pos = left.position * -1
		old_pos1 = left.position
		old_pos2 = right.position

		success = false
		Chapter.transaction do
			left.position = temp_pos
			success = left.save

			right.position = old_pos1
			success = right.save && success

			left.position = old_pos2
			success = left.save && success
		end
		return success
	end

	# PRIVATE METHODS
	private

	# SetPosition
	# - set the correct position if it does not exist
	def set_position
		self.position ||= story.newest_chapter_position
	end

end
