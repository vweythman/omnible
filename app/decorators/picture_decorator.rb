class PictureDecorator < Draper::Decorator

	# DELEGATION
	# ------------------------------------------------------------
	delegate_all

	def preview_area
		h.preview_area(art_src)
	end

end
