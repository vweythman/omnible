module Pathable

	def path_footer
		h.render "shared/path_footer", links: path_links
	end

	def path_links
		{}
	end
end
