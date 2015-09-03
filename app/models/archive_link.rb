# ArchiveLink
# ================================================================================
# type of link
# see Source for table variables

class ArchiveLink < Source

	# PUBLIC METHODS
	# ------------------------------------------------------------
	# Heading - defines the main means of addressing the model
	def heading
		"Avaliable at #{host.name}"
	end

end
