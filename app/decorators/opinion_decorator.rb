class OpinionDecorator < ViewpointDecorator
	delegate_all

	# RecipHeading - gives the heading for the recipient
	def recip_heading
		recip.name
	end

end
