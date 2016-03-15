class CharacterInfoDecorator < Draper::Decorator
	
	# DELEGATION
	# ------------------------------------------------------------
	delegate_all

	# PUBLIC METHODS
	# ------------------------------------------------------------
	def subheading
		if self.title.present?
			h.content_tag :h2, class: "subheading" do
				self.title
			end
		end
	end

	def has_content?
		!self.content.nil? && self.content != ""
	end

end
