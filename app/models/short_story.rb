# ShortStory
# ================================================================================
# type of narrative work
# see Work for table variables

class ShortStory < Work

	# CALLBACKS
	# ------------------------------------------------------------
	before_save   :contentize, on: [:update, :create]
	before_create :set_categories

	# ASSOCIATIONS
	# ------------------------------------------------------------
	has_many :notes,    :inverse_of => :work,  foreign_key: "work_id"
	has_one  :chapter,  :inverse_of => :story, foreign_key: "story_id"
	has_many :comments, :through => :chapter

	# DELEGATED METHODS
	# ------------------------------------------------------------
	delegate :content,   to: :chapter
	delegate :afterward, to: :chapter

	# ATTRIBUTES
	# ------------------------------------------------------------
	attr_accessor :story_content

	def story_content
		if self.chapter.nil?
			@story_content ||= ""
		else
			@story_content ||= self.chapter.content
		end
	end

	# PUBLIC METHODS
	# ------------------------------------------------------------
	# NewChapter - creates a new chapter
	def new_chapter
		self.chapter = Chapter.new
		self.chapter.position = 1

		return self.chapter
	end

	# UpdateContent - change the story's content
	def update_content(content)
		self.chapter.content = content
		chapter.save
	end

	# PRIVATE METHODS
	# ------------------------------------------------------------
	private

	# CALLBACK METHODS
	# ............................................................
	# set default categories
	def set_categories
		self.status = 'complete'
	end

	def contentize
		self.chapter ||= Chapter.new
		self.chapter.position = 1
		self.chapter.content = @story_content
	end

end
