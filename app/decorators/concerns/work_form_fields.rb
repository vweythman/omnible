# WorkFields
# ============================================================
# Collecting work form values values in one module
# ============================================================

module WorkFormFields

	# PUBLIC METHODS
	# ============================================================
	# GETTERS
	# ------------------------------------------------------------
	# Variables
	# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	def chooseable_skins
		uploader.skins
	end

	def location_heading
		self.narrative? ? "Settings" : "Subject (Location)"
	end

	# Partial Locations
	# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	def creatorship_fields
		self.record? ? 'works/shared/fields/creatorship_fields' : 'works/shared/fields/creatorship_local_fields'
	end

	def meta_fields
		"works/shared/fields/meta_fields"
	end

	def tag_fields
		"works/shared/fields/tag_fields"
	end

	# SETTERS
	# ------------------------------------------------------------
	def form_setup(params)
		object.skinning ||= Skinning.new
	end

	def created_by(creator_id)
		visitor.pseudonymings.find_by_id(creator_id).character
	end

	def visitor
		object.visitor || h.current_user
	end

end
