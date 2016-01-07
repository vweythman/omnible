class CharacterInfoDecorator < Draper::Decorator
	
	# DELEGATION
	# ------------------------------------------------------------
	delegate_all

	# PUBLIC METHODS
	# ------------------------------------------------------------
	def subheading
		if self.title.present?
			h.content_tag :h2 do
				self.title
			end
		end
	end

end
