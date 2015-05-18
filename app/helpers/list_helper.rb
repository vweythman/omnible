module ListHelper
	# OUTPUT comma separated links
	def cslinks(links)
		elements = Array.new
		links.each do |item|
			elements.push link_to(item.name, item)
		end
		elements.join(", ").html_safe
	end

	# OUTPUT comma separated list
	def cslist(models)
		list = Array.new()
		models.each do |model|
			list.push model.heading
		end

		list.join(", ").html_safe
	end
end
