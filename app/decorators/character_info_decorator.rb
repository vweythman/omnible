class CharacterInfoDecorator < Draper::Decorator
	delegate_all

	def subheading
		if self.title.present?
			h.content_tag :h2 do
				self.title
			end
		end
	end

end
