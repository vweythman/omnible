module Widgets
	module Definitions

		def definitions
			h.render 'shared/lists/definitions', listable: listable
		end

		def results
			h.render 'shared/results/simple', type: 'definitions', listable: listable
		end

		def listable
			@listable ||= organized
		end

	end
end
