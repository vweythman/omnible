class PenNamingsDecorator < Draper::CollectionDecorator

	def link_to_creation
		h.inline_creation_toolkit "Pen Name", h.new_pen_naming_path
	end

end
