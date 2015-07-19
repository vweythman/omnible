# Taggable Methods
# ================================================================================
# 
# Questions
# --------------------------------------------------------------------------------
#  method name                 | description
# --------------------------------------------------------------------------------
#  is_subject?                 | answers that model is not a subject
# ================================================================================

module Taggable

	# METHODS
	# ------------------------------------------------------------
	# IsSubject?
	# - answers that model is not a subject
	def is_subject?
		false
	end

	# Linkable
	# - grab what will be used when organizing
	def linkable
		self
	end

end
