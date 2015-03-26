module IndexHelper
	def cslinks(links)
		elements = Array.new
		links.each do |item|
			elements.push link_to(item.name, item)
		end

		content_tag :p do 
			elements.join(", ").html_safe
		end
	end

	# comma separated list
	def cslist(models)
		list = Array.new()
		models.each do |model|
			list.push model.main_title
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
