module Widgets
	module SnippetResults

		def snippets
			h.render 'shared/results/snippets', listable: self
		end

		def ordered_snippets(ordering = :updated_by)
		end

	end
end
