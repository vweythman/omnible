module Summarizable
	def excerpt
		txt = self.summary
		if self.summary.present? && txt.length > 120
			txt[0, 120].strip + "..."
		else
			txt
		end
	end
end
