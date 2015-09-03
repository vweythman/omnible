# Article
# ================================================================================
# type of non-narrative work
# see Work for table variables

class Article < Nonfiction
	
	# ASSOCIATIONS
	# ------------------------------------------------------------
	has_one  :note,     :inverse_of => :work, foreign_key: "work_id"
	has_many :comments, :through => :note

	# DELEGATED METHODS
	# ------------------------------------------------------------
	delegate :content, to: :note

end
