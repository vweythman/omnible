# Casting
# ================================================================================
# type of non-narrative work
# see Work for table variables

class Casting < Work

	# VALIDATIONS
	# ============================================================
	validates :roll_calls, presence: true

	# CALLBACKS
	# ============================================================
	before_validation :set_characters, on: [:update, :create]

	# ASSOCIATIONS
	# ============================================================
	has_many :roll_calls, inverse_of: :casting
	accepts_nested_attributes_for :roll_calls, allow_destroy: :true

	# PRIVATE METHODS
	# ============================================================
	private

	def set_characters
		roll_calls.each do |r|
			c = Character.where(name: r.title).first_or_create
			r.character_id = c.id
		end
	end

end
