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
#  complete_heading            | string      | defines the full chapter heading
#  word_count                  | integer     | count the number of words in the 
#                              |             | chapter contents
#  prev                        | object      | finds the previous chapter
#  next                        | object      | finds the next chapter
#  editable                    | bool        | user is allowed to edit
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
	# - :: string
	def heading
		if title.empty?
			"Chapter #{self.position}"
		else
			title
		end
	end

	# CompleteHeading
	# - defines the full chapter heading
	# - :: string
	def complete_heading
		current_title = "Chapter #{self.position}"
		current_title.concat " - #{self.title}" unless title.empty?
		current_title
	end

	# WordCount
	# - count the number of words in the chapter contents
	# - :: integer
	def word_count
		I18n.transliterate(self.content).scan(/[\w-]+/).size
	end

	# Prev
	# - finds the previous chapter
	# - :: object
	def prev
		@prev.nil? ? @prev = Chapter.where("work_id = ? AND position = ?", self.work_id, (self.position - 1)).first : @prev
	end

	# Next
	# - finds the next chapter
	# - :: object
	def next
		@next.nil? ? @next = Chapter.where("work_id = ? AND position = ?", self.work_id, (self.position + 1)).first : @next
	end

	# Editable
	# - user is allowed to edit
	# - :: bool
	def editable?(user)
		
	end

	# CLASS METHODS
	# NewestPosition
	# - outputs the newest positional chapter number
	def self.newest_position(work)
		work.chapters.length + 1 
	end

end
