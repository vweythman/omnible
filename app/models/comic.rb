# Comic
# ================================================================================
# type of narrative work
# see Work for table variables

class Comic < Work

	# ASSOCIATIONS
	# ============================================================
	has_many :pictures, inverse_of: :work, foreign_key: "work_id"

	# NESTED ATTRIBUTION
	# ============================================================
	accepts_nested_attributes_for :pictures, allow_destroy: :true

end
