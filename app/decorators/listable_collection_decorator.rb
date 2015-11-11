class ListableCollectionDecorator < Draper::CollectionDecorator

	def list
		h.render partial: list_partial, object: self
	end
	
	def list_partial
		"shared/lists/#{list_type}"
	end

	private
	def list_type
		:unordered
	end

end
