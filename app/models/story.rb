# Story
# ================================================================================
# type of narrative work
# see Work for table variables

class Story < Work

	# ASSOCIATIONS
	# ------------------------------------------------------------
	has_many :notes,    :inverse_of => :work, foreign_key: "work_id"
	has_many :chapters, :inverse_of => :story
	has_many :comments, :through => :chapters

	# NESTED ATTRIBUTION
	# ------------------------------------------------------------
	accepts_nested_attributes_for :chapters, :allow_destroy => true

	# PUBLIC METHODS
	# ------------------------------------------------------------
	# NewChapter - creates a new chapter
	def new_chapter
		chapter = Chapter.new
		chapter.story    = self
		chapter.position = self.newest_chapter_position

		return chapter
	end

	# NewestChapterPosition - get position for newest chapter
	def newest_chapter_position
		self.chapters.size + 1
	end

	# ContentDistribution - collects the totals number of chapters and notes
	def content_distribution
		@content_distribution ||= {
			:chapters => self.chapters.size,
			:notes    => self.notes.size
		}
	end

end
