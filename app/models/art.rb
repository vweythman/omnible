# Art
# ================================================================================
# type of non-narrative work
# see Work for table variables

class Art < Work

	# VALIDATIONS
	# ============================================================
	validates :picture, presence: true

	# CALLBACKS
	# ============================================================
	before_create :set_categories

	# ASSOCIATIONS
	# ============================================================
	has_one :picture, inverse_of: :work, foreign_key: "work_id", dependent: :destroy

	# NESTED ATTRIBUTION
	# ============================================================
	accepts_nested_attributes_for :picture, allow_destroy: :true

	# PUBLIC METHODS
	# ============================================================
	def image_url
		picture.artwork_url
	end

	# PRIVATE METHODS
	# ============================================================
	private

	def set_categories
		self.status = 'complete'
	end

end
