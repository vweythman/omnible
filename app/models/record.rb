# Record
# ================================================================================
# type of work
# see Work for table variables

class Record < Work

	# DELEGATED METHODS
	# ============================================================
	delegate :medium, to: :metadata

	# PUBLIC METHODS
	# ============================================================
	# QUESTIONS 
	# ------------------------------------------------------------
	def editable?(user)
		!user.nil? && user.admin?
	end

	def destroyable?(user)
		!user.nil? && user.admin?
	end

	def viewable?(user)
		true
	end

end
