class RollCallDecorator < TagDecorator

	# DELEGATION
	# ------------------------------------------------------------
	delegate_all

	def character_name
		character.name unless character.nil?
	end

end
