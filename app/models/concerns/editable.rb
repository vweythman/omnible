module Editable
	include Viewable

	PRIVATE_ONLY   = 0
	INVITED        = 1
	MEMBERS        = 2
	PUBLIC         = 3

	def invite_editable?(editor)
		self.editor_level == Editable.INVITED
		# and has editor
	end

	def membership_editable?(editor)
		self.editor_level == Editable.MEMBERS && !editor.nil?
	end

	def edits_public?
		self.editor_level == Editable.PUBLIC
	end

	def editor?(editor)
		# check invited editors list
		false
	end

	# Editable?
	# - asks if character can be edited
	def editable?(editor)
		editor?(editor) || edits_public? || invite_editable?(editor) || membership_editable?(editor)
	end

end