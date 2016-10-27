# Audible
# ================================================================================
# see Work for table variables
#
# ================================================================================

class Audible < Work


	# PRIVATE METHODS
	# ============================================================
	private

	# ............................................................
	# Sanitized Filename - get the base file name and replace
	# anything that is not a word, a dot, a dash, or an underscore
	# with an underscore
	# ............................................................
	def sanitized_filename
		base_filename = File.basename(filename)
		base_filename.sub(/[^\w\.\-\_]/,'_')
	end

end
