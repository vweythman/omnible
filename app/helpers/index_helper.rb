module IndexHelper
	def cslinks(links)
		elements = Array.new
		links.each do |item|
			elements.push link_to(item.name, item)
		end

		csindex(elements)
	end

	def csindex(list)
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
