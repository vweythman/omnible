# Article
# ================================================================================
# type of non-narrative work
# see Work for table variables

class Article < Nonfiction
	
	# CALLBACKS
	# ------------------------------------------------------------
	after_save    :contentize, on: [:update, :create]
	before_create :set_categories

	# ASSOCIATIONS
	# ------------------------------------------------------------
	has_one  :note,     :inverse_of => :work, foreign_key: "work_id"
	has_many :comments, :through => :note

	# DELEGATED METHODS
	# ------------------------------------------------------------
	delegate :content, to: :note

	# ATTRIBUTES
	# ------------------------------------------------------------
	attr_accessor :article_content

	def article_content
		if self.note.nil?
			@article_content ||= ""
		else
			@article_content ||= self.note.content
		end
	end

	# PRIVATE METHODS
	# ------------------------------------------------------------
	private

	# set default categories
	def set_categories
		self.is_complete = true
	end

	def contentize
		self.note ||= Note.new
		self.note.content = article_content
		note.save
	end

end
