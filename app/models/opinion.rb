class Opinion < Viewpoint

	# NONTABLE VARIABLES
	# ------------------------------------------------------------
	def after_initialize()
		recip_type = 'Character'
	end

	def recip_heading
		recip.name
	end

end
