class OpinionDecorator < ViewpointDecorator

	# DELEGATION
	# ------------------------------------------------------------
	delegate_all

	# PUBLIC METHODS
	# ------------------------------------------------------------
	def recip_heading
		recip.name
	end

end
