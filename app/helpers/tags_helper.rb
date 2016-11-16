module TagsHelper

	# BLOCK OUTPUT
	# ============================================================
	def tag_group(list, group, group_options = {}, tag_options = {})
		content_tag :p, group_options do
			cstags(list, group, tag_options)
		end
	end

	# TEXT OUTPUT
	# ============================================================
	def cstags(links, choice, link_options={})
		r = links.map {|i|
			ul = 
			link_to i.heading, (url_for(i) + '/' + choice), link_options
		}.join(", ").html_safe
	end

	def indexed_tagging(title, type, count, path)
		if count.present? && count > 0
			content_tag :li, class: 'icon icon-books' do
				(" " + link_to("#{title}: #{type} (#{count})", path)).html_safe
			end
		end
	end
	
	def tag_label_by(type, key = nil)
		tag_label = "#{type}-tag tag"
		tag_label = "#{key}-#{type} #{tag_label}" unless key.nil?
		tag_label
	end

end
