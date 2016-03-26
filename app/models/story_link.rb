# StoryLink
# ================================================================================
# type of narrative work
# see Work for table variables

class StoryLink < Work

	# VALIDATIONS
	# ============================================================
	validates_presence_of :sources

	# CALLBACKS
	# ============================================================
	before_create :set_categories

	# PRIVATE METHODS
	# ============================================================
	private

	# set default categories
	def set_categories
		self.status = 'unknown'
	end

end
