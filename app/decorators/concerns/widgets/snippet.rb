module Widgets
	module Snippet

		def partial_prepend
			klass.to_s.downcase.pluralize + '/'
		end

		def snippet_path
			partial_prepend + 'snippet'
		end

	end
end
