class PenNamingsDecorator < Draper::CollectionDecorator

	def link_to_creation
		h.inline_creation_toolkit "Pen Name", :pen_naming
	end

end
