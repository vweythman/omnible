class PlacesDecorator < ListableCollectionDecorator

	def results
		if object.length > 0
			h.content_tag :section, class: "results" do
				h.content_tag :article do list end
			end
		end
	end

	def list
		h.render partial: list_partial, object: Place.organize(object) 
	end

	private
	def list_type
		:definitions
	end

end
