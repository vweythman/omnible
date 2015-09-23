class PrejudiceDecorator < ViewpointDecorator
	delegate_all

	# RecipHeading - gives the heading for the recipient
	def recip_heading
		identity.name.titleize.pluralize
	end

end
