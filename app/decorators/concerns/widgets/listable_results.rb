module Widgets
	module ListableResults

		def results(type = 'links')
			h.render 'shared/results/simple', type: type, listable: self
		end
		
	end
end
