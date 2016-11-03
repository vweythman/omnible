# Comic
# ================================================================================
# type of narrative work
# see Work for table variables

class Comic < Work

	# VALIDATIONS
	# ============================================================
	validates :pages, presence: true

	# ASSOCIATIONS
	# ============================================================
	has_many :pages, inverse_of: :work, foreign_key: "work_id", class_name: "Picture"

	# NESTED ATTRIBUTION
	# ============================================================
	accepts_nested_attributes_for :pages, allow_destroy: :true

end
