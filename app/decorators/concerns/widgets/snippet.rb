module Widgets
	module Snippet

		def snippet_path
			'shared/snippets/' + klass.to_s
		end

	end
end