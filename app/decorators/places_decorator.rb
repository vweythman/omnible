class PlacesDecorator < Draper::CollectionDecorator

	def results
		if object.length > 0
			
			list =  h.content_tag :article do 
				h.render partial: "shared/definitions", object: Place.organize(object) 
			end
			
			h.content_tag :section, class: "results" do
				list
			end
		end
	end

end
