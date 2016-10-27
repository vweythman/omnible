class PictureDecorator < Draper::Decorator

	# DELEGATION
	# ------------------------------------------------------------
	delegate_all

	def preview_area
		h.content_tag :div, class: "preview-area" do
			h.image_tag(art_src, alt: "image preview", class: "image-preview")
		end
	end

	def art_src
		artwork.nil? ? '#' : artwork_url
	end

end
