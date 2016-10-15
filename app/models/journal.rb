# Journal
# ================================================================================
# type of narrative work
# see Work for table variables

class Journal < Work

	# ASSOCIATIONS
	# ------------------------------------------------------------
	has_many :articles, inverse_of: :story, foreign_key: "story_id", class_name: "Chapter"
	has_many :comments, through: :articles

	# NESTED ATTRIBUTION
	# ------------------------------------------------------------
	accepts_nested_attributes_for :articles, :allow_destroy => true

	# PUBLIC METHODS
	# ------------------------------------------------------------

end
