# Article
# ================================================================================
# type of non-narrative work
# see Work for table variables

class Article < Work
	
	# CALLBACKS
	# ------------------------------------------------------------
	before_save   :contentize, on: [:update, :create]
	before_create :set_categories

	# ASSOCIATIONS
	# ------------------------------------------------------------
	has_one  :chapter,  inverse_of: :story, foreign_key: "story_id"
	has_many :comments, through:    :chapter

	# DELEGATED METHODS
	# ------------------------------------------------------------
	delegate :content, to: :chapter

	# ATTRIBUTES
	# ------------------------------------------------------------
	attr_accessor :article_content

	def article_content
		if self.chapter.nil?
			@article_content ||= ""
		else
			@article_content ||= self.chapter.content
		end
	end

	# PRIVATE METHODS
	# ------------------------------------------------------------
	private

	# set default categories
	def set_categories
		self.status = 'complete'
	end

	def contentize
		self.chapter ||= Chapter.new
		self.chapter.content  = @article_content
		self.chapter.position = 1
	end

end
