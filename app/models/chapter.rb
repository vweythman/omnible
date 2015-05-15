# Chapter
# ================================================================================
# chapter is a subpart of works
#
# Variables (max length: 15 characters) 
# --------------------------------------------------------------------------------
#  variable name   | type        | about
# --------------------------------------------------------------------------------
#  id              | integer     | unique
#  title           | string      | maximum of 250 characters
#  content         | text        | cannot be null
#  work_id         | integer     | cannot be null
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
#  simple_heading              | string      | defines the simplified chapter
#                              |             | heading
#  prev                        | model       | finds the previous chapter
#  next                        | model       | finds the next chapter
#  self.newest_position        | integer     | outputs the newest positional
#                              |             | chapter number
# ================================================================================

class Chapter < ActiveRecord::Base

	# VALIDATIONS and SCOPES
	# ------------------------------------------------------------
	validates :work_id, presence: true
	validates :content, presence: true
	validates_uniqueness_of :position, :scope => :work_id

	# ASSOCIATIONS
	# ------------------------------------------------------------
	belongs_to :work, :inverse_of => :chapters

	# METHODS
	# ------------------------------------------------------------
	# Heading
	# - defines the main means of addressing the model
	def heading
		if title.empty?
			"#{work.title} | Chapter #{self.position}"
		else
			"#{work.title} | #{title}"
		end
	end

	# SimpleHeading
	# - defines the simplified chapter heading
	def simple_heading
		current_title = "Chapter #{self.position}"
		current_title.concat " - #{self.title}" unless title.empty?
		current_title
	end

	# Prev
	# - finds the previous chapter
	def prev
		@prev.nil? ? @prev = Chapter.where("work_id = ? AND position = ?", self.work_id, (self.position - 1)).first : @prev
	end

	# Next
	# - finds the next chapter
	def next
		@next.nil? ? @next = Chapter.where("work_id = ? AND position = ?", self.work_id, (self.position + 1)).first : @next
	end

	# CLASS METHODS
	# NewestPosition
	# - outputs the newest positional chapter number
	def self.newest_position(work)
		work.chapters.length + 1 
	end

	def editable?(user)
		
	end


end
