# PenNaming
# ================================================================================
# see Pseudonyming for table variables

class PenNaming < Pseudonyming

	# PUBLIC METHODS
	# ------------------------------------------------------------
	def new_character
		self.character ||= Character.new
	end

	def set_character_behavior
		self.character.uploader_id     = self.user.id
		self.character.allow_play      = false
		self.character.allow_clones    = false
		self.character.allow_as_clone  = false
		self.character.can_connect     = false
		self.character.is_fictional    = false
		self.character.editor_level    = Editable::PRIVATE
		self.character.publicity_level = Editable::PRIVATE
	end

end
