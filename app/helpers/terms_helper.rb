module TermsHelper

	def graph_edge(name, edge_terms)
		content_tag :div, :class => 'terms' do
			concat graph_header(name, edge_terms.length) 
			concat link_to("Set Relationships", new_term_edge_path)
			concat graph_list(edge_terms)
		end
	end

	def graph_header(name, count)
		content_tag :h2 do 
			name.pluralize(count)
		end
	end

	def graph_list edges
		content_tag :ul do
	      edges.collect {|edge| concat(content_tag(:li, link_to(edge.name, edge)))}
	 	end
	end
end
