class Prejudice < Viewpoint

	# NONTABLE VARIABLES
	# ------------------------------------------------------------
	def after_initialize()
		recip_type = 'Identity'
	end

	def recip_heading
		recip.name.titleize.pluralize
	end

end
