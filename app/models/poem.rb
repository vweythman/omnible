# Poem
# ================================================================================
# type of non-narrative work
# see Work for table variables

class Poem < Work
	
	# CALLBACKS
	# ============================================================
	after_save    :contentize,      on: [:update, :create]
	after_save    :update_metadata, on: [:update, :create]
	before_create :set_categories

	# SCOPES
	# ============================================================
	scope :by_lines, -> { order("(SELECT value FROM record_quantitative_metadata WHERE story_id = works.id AND key = 'line-count') desc") }

	# ASSOCIATIONS
	# ============================================================
	has_many :notes,    :inverse_of => :work,  foreign_key: "work_id"
	has_one  :chapter,  :inverse_of => :story, foreign_key: "story_id"
	has_many :comments, :through => :chapter

	# DELEGATED METHODS
	# ============================================================
	delegate :content, to: :chapter

	# CLASS METHODS
	# ============================================================
	def self.order_by(choice)
		if choice == "line-count"
			by_lines
		else
			super(choice)
		end
	end

	# ATTRIBUTES
	# ============================================================
	attr_accessor :poem_content
	def poem_content
		if self.chapter.nil?
			@poem_content ||= ""
		else
			@poem_content ||=  self.chapter.content
		end
	end

	# PUBLIC METHODS
	# ============================================================
	def linefy
		poem_content.split("\n")
	end

	def count_lines
		linefy.count
	end

	# PRIVATE METHODS
	# ============================================================
	private

	# set default categories
	def set_categories
		self.status = 'complete'
	end

	def contentize
		self.chapter ||= Chapter.new
		self.chapter.position = 1
		self.chapter.content  = poem_content
		self.chapter.save
	end

	def update_metadata
		counter       = qualitatives.datum("line-count")
		counter.value = count_lines
		counter.save
	end

end
