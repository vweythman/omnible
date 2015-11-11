# ShortStory
# ================================================================================
# type of narrative work
# see Work for table variables

class ShortStory < Work

	# CALLBACKS
	# ------------------------------------------------------------
	before_create :set_categories
	after_initialize :add_chapter

	# ASSOCIATIONS
	# ------------------------------------------------------------
	has_many :notes,    :inverse_of => :work, foreign_key: "work_id"
	has_one  :chapter,  :inverse_of => :story, foreign_key: "story_id"
	has_many :comments, :through => :chapter

	# DELEGATED METHODS
	# ------------------------------------------------------------
	delegate :content,   to: :chapter
	delegate :afterward, to: :chapter

	# PUBLIC METHODS
	# ------------------------------------------------------------
	# NewChapter - creates a new chapter
	def new_chapter
		chapter = Chapter.new
		chapter.story    = self
		chapter.position = 1

		return chapter
	end

	# UpdateContent - change the story's content
	def update_content(content)
		self.chapter.content = content
		chapter.save
	end

	# ContentDistribution - collects the totals number of chapters and notes
	def content_distribution
		@content_distribution ||= {
			:chapters => 1,
			:notes    => self.notes.size
		}
	end

	# PRIVATE METHODS
	# ------------------------------------------------------------
	private

	# CALLBACK METHODS
	# ............................................................
	# set default categories
	def set_categories
		self.is_complete  = true
	end

	def add_chapter
		self.chapter ||= Chapter.new
		self.chapter.position = 1
	end

end
