# PenNaming
# ================================================================================
# see Pseudonyming for table variables

class PenNaming < Pseudonyming

	# CALLBACKS
	# ------------------------------------------------------------
	after_create :default_character_behavior

	# PUBLIC METHODS
	# ------------------------------------------------------------
	def new_character
		self.character ||= Character.new
	end

	# PRIVATE METHODS
	# ------------------------------------------------------------
	private
	def default_character_behavior
		self.character.uploader_id     = self.user.id
		self.character.allow_play      = false
		self.character.allow_clones    = false
		self.character.allow_as_clone  = false
		self.character.is_fictional    = false
		self.character.editor_level    = Editable::PRIVATE
		self.character.publicity_level = Editable::PRIVATE
		self.character.save
	end

end
