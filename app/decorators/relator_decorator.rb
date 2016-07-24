class RelatorDecorator < TagDecorator

	# DELEGATION
	# ------------------------------------------------------------
	delegate_all

	# PUBLIC METHODS
	# ------------------------------------------------------------
	# Heading - defines the main means of addressing the model
	def formid
		"[relator][" + default_direction + "][" + self.id.to_s + "]"
	end
	
end
