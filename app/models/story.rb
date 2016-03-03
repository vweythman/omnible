# Story
# ================================================================================
# type of narrative work
# see Work for table variables

class Story < Work

	# SCOPES
	# ============================================================
	scope :by_chapters, -> { order("(SELECT COUNT(*) FROM chapters WHERE story_id = works.id) desc") }

	# ASSOCIATIONS
	# ============================================================
	has_many :notes,    :inverse_of => :work, foreign_key: "work_id"
	has_many :chapters, :inverse_of => :story
	has_many :comments, :through => :chapters

	# NESTED ATTRIBUTION
	# ============================================================
	accepts_nested_attributes_for :chapters, :allow_destroy => true

	# CLASS METHODS
	# ============================================================
	def self.order_by(choice)
		case choice
		when "chapter-count"
			by_chapters
		else
			super(choice)
		end
	end

	# PUBLIC METHODS
	# ============================================================
	# NewChapter - creates a new chapter
	def new_chapter
		chapter = Chapter.new
		chapter.story    = self
		chapter.position = self.newest_chapter_position

		return chapter
	end

	# NewestChapterPosition - get position for newest chapter
	def newest_chapter_position
		latest = self.chapters.order("position DESC").first
		latest.nil? ? 1 : latest.position + 1
	end

end
