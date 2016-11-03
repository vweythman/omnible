# WorkFields
# ============================================================
# TABLE of CONTENTS
# ============================================================
# PUBLIC METHODS
# -- SELECT LISTS
# ----- chooseable_skins
#
# -- SELECT MODELS
# ----- created_by
# ----- form_setup
# ----- visitor
#
# -- SELECT TEXT
# ----- creatorship_fields
# ----- location_heading
# ----- meta_fields
# ----- tag_fields
#
# ============================================================

module WorkFormFields

	# PUBLIC METHODS
	# ============================================================
	# ------------------------------------------------------------
	# SELECT LISTS
	# ------------------------------------------------------------
	def chooseable_skins
		uploader.skins
	end

	# ------------------------------------------------------------
	# SELECT MODELS
	# ------------------------------------------------------------
	def created_by(creator_id)
		visitor.pseudonymings.find_by_id(creator_id).character
	end

	def form_setup(params)
		object.skinning ||= Skinning.new
	end

	def visitor
		object.visitor || h.current_user
	end

	# ------------------------------------------------------------
	# SELECT TEXT
	# ------------------------------------------------------------
	def creatorship_fields
		self.record? ? 'works/shared/fields/creatorship_fields' : 'works/shared/fields/creatorship_local_fields'
	end

	def location_heading
		self.narrative? ? "Settings" : "Subject (Location)"
	end

	def meta_fields
		"works/shared/fields/meta_fields"
	end

	def tag_fields
		"works/shared/fields/tag_fields"
	end

end
