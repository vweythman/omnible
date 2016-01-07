module Agented

	def uploaded_by
		h.content_tag :p, class: 'agents' do
			("Uploaded by " + h.link_to(uploader.name, uploader)).html_safe
		end
	end

	def byline
		h.content_tag :span, class: 'byline' do
			("By " + h.link_to(uploader.name, uploader)).html_safe
		end
	end

end
