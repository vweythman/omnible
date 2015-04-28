module IndexHelper
	
	def cslinks(links)
		elements = Array.new
		links.each do |item|
			elements.push link_to(item.name, item)
		end
		elements.join(", ").html_safe
	end

	# comma separated list
	def cslist(models)
		list = Array.new()
		models.each do |model|
			list.push model.heading
		end

		list.join(", ").html_safe
	end

	def ul_index(list)
	end

	def dl_index(list)
		content_tag :ol, class: 'index' do
		end
	end

	def ol_index(list)
		content_tag :ol, class: 'index'  do 
		end
	end
end
