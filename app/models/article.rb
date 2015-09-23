# Article
# ================================================================================
# type of non-narrative work
# see Work for table variables

class Article < Nonfiction
	
	# CALLBACKS
	# ------------------------------------------------------------
	before_create :set_categories
	after_initialize :add_note

	# ASSOCIATIONS
	# ------------------------------------------------------------
	has_one  :note,     :inverse_of => :work, foreign_key: "work_id"
	has_many :comments, :through => :note

	# DELEGATED METHODS
	# ------------------------------------------------------------
	delegate :content, to: :note

	# PUBLIC METHODS
	# ------------------------------------------------------------
	# UpdateContent - change content of note
	def update_content(content)
		self.note.content = content
		note.save
	end

	# PRIVATE METHODS
	# ------------------------------------------------------------
	private

	# set default categories
	def set_categories
		self.is_narrative = false
		self.is_singleton = true
		self.is_complete  = true
	end

	def add_note
		self.note ||= Note.new
	end
end
