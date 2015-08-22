class ShortStory < Work

	# ASSOCIATIONS
	# ------------------------------------------------------------
	has_one  :chapter,  :inverse_of => :story, foreign_key: "story_id"
	has_many :comments, :through => :chapter

	# PUBLIC METHODS
	# ------------------------------------------------------------
	# NewChapter - creates a new chapter
	def new_chapter
		chapter = Chapter.new
		chapter.story    = self
		chapter.position = 1

		return chapter
	end

	# ContentDistribution - collects the totals number of chapters and notes
	def content_distribution
		@content_distribution ||= {
			:chapters => 1,
			:notes    => self.notes.size
		}
	end

end
