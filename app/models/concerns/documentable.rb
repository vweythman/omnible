# Documentable Methods
# ================================================================================
# methods for the subject group of tags
# 
# Declarations
# --------------------------------------------------------------------------------
# none yet
#
# Questions
# output type is always bool
# --------------------------------------------------------------------------------
#  method name                 | description
# --------------------------------------------------------------------------------
#  is_subject?                 | answers whether model is a member of the idea or
#                              | subject group of tags
# ================================================================================

module Documentable

	# QUESTIONS
	# ------------------------------------------------------------
	# is_subject?
	# - answers whether model is a member of the idea or subject 
	#   group of tags
	def is_subject?
		true
	end

	def heading
		self.name unless self.name.nil?
	end

end
