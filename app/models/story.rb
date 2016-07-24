# Story
# ================================================================================
# type of narrative work
# see Work for table variables

class Story < Work

	# CALLBACKS
	# ------------------------------------------------------------
	after_save :update_metadata, on: [:update, :create]

	# SCOPES
	# ============================================================
	scope :by_chapters, -> { order("(SELECT COUNT(*) FROM chapters WHERE story_id = works.id) desc") }

	# ASSOCIATIONS
	# ============================================================
	has_many :notes,    inverse_of: :work, foreign_key: "work_id"
	has_many :chapters, inverse_of: :story
	has_many :comments, through:    :chapters

	has_one  :chapter_counter,   ->{ RecordQuantitativeMetadatum.chapter_counts  }, foreign_key: "work_id", class_name: "RecordQuantitativeMetadatum"
	has_one  :first_chapter_id,  ->{ RecordMetadatum.first_chapter   }, foreign_key: "work_id", class_name: "RecordMetadatum"
	has_one  :latest_chapter_id, ->{ RecordMetadatum.lastest_chapter }, foreign_key: "work_id", class_name: "RecordMetadatum"

	# NESTED ATTRIBUTION
	# ============================================================
	accepts_nested_attributes_for :chapters, allow_destroy: :true

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
	def chapter_count
		chapter_counter.value
	end

	def taggable_chapter_count
		t = searchable_quantitative_metadata["chapter-count"]
		t ||= -1
		t
	end

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

	def update_positioning(ordered_chapters = nil)
		ordered_chapters ||= chapters.ordered
		first_chapter_id = qualitatives.datum("first-chapter")
		first_chapter_id.value = ordered_chapters.first.id
		first_chapter_id.save

		latest_chapter_id = qualitatives.datum("latest-chapter")
		latest_chapter_id.value = ordered_chapters.last.id
		latest_chapter_id.save
	end

	def update_counter(ccount = nil)
		ccount          ||= chapters.count
		chapter_counter = quantitatives.datum("chapter-count")
		chapter_counter.value = ccount
		chapter_counter.save
	end

	def update_metadata
		ordered_chapters = chapters.ordered
		update_counter(ordered_chapters.length)

		if ordered_chapters.length > 0
			update_positioning ordered_chapters
		end
	end

end
