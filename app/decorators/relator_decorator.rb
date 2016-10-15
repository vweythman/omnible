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

	def right_table_heading
		(has_reverse? ? right_name : left_name).titleize
	end
	
end
