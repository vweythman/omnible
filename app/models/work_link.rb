# WorkLink
# ================================================================================
# type of narrative work
# see Work for table variables

class WorkLink < Work

	# VALIDATIONS
	# ============================================================
	validates_presence_of :sources

	# CALLBACKS
	# ============================================================
	before_create :set_categories

	# ASSOCIATIONS
	# ============================================================
	has_many :sources, :dependent  => :destroy,  as: :referencer

	# NESTED ATTRIBUTION
	# ============================================================
	accepts_nested_attributes_for :sources,  :allow_destroy => true

	# PRIVATE METHODS
	# ============================================================
	private

	# set default categories
	def set_categories
		self.status = 'unknown'
	end

end
