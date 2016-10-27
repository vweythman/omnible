module TabsHelper

	def paged_anchor(model, default_title, position)
		link_url    = "#page-#{position}"
		link_id     = "page-#{position}-anchor"
		link_class  = "has-errors" if model.errors.any?
		data_errors = model.errors.count

		anchor_title = model.title.present? ? model.title : default_title

		content_tag :li do
			link_to anchor_title, link_url, id: link_id, class: link_class, data: { errors: data_errors }
		end
	end

end
