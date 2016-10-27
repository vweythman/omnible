class FacetDecorator < TagDecorator

	# DELEGATION
	# ------------------------------------------------------------
	delegate_all

	# MODULES
	# ------------------------------------------------------------
	include AlphabeticPagination
	include InlineEditing

	def identity_distribution
		@identity_distribution ||= identities.alphabetic.with_usage_count
	end

	def pie_dataset
		labels   = []
		datasets = { data: [], backgroundColor: [], borderColor: [] }
		values   = identity_distribution.map {|i| [i.name, i.full_count] }

		values.each do |label, count| 
			hex   = h.dataset_color
			r,g,b = h.hex_to_rgb_color(hex)

			labels << label
			datasets[:data] << count
			datasets[:borderColor]     << "#" + hex
			datasets[:backgroundColor] << "rgba(#{r},#{g},#{b},0.4)"
		end

		data = { labels: labels, datasets: [datasets] }
		data.to_json.to_s.html_safe
	end

end
