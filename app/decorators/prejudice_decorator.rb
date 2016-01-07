class PrejudiceDecorator < ViewpointDecorator

	# DELEGATION
	# ------------------------------------------------------------
	delegate_all

	# PUBLIC METHODS
	# ------------------------------------------------------------
	# RecipHeading - gives the heading for the recipient
	def recip_heading
		identity.name.titleize.pluralize
	end

end
