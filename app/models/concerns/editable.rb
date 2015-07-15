module Editable
	include Viewable

	# METHODS
	# ------------------------------------------------------------
	# InvitedEditor?
	# - viewer is on invite list
	def invited_editor?(editor)
		self.invited_editors.include?(editor)
	end

	# Editable?
	# - asks if character can be edited
	def editable?(editor)
		@reader = editor
		@level  = self.editor_level
		creator?(@reader) || for_public? || invited_editor?(@reader) || check_restrictions
	end

end
