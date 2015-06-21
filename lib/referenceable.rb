# Referenceable Methods
# ================================================================================
# methods for models that can act as general tags for other models
#
# Questions
# output type is always true or false - boolean
# --------------------------------------------------------------------------------
#  method name                 | description
# --------------------------------------------------------------------------------
#  is_subject?                 | answers that model is not a subject
# ================================================================================

module Referenceable

	# QUESTIONS
	# ------------------------------------------------------------
	# IsSubject?
	# - answers that model is not a subject
	def is_subject?
		false
	end

end