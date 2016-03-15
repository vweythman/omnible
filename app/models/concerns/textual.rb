require 'active_support/concern'

module Textual
	extend ActiveSupport::Concern

	# CLASS METHODS
	# ============================================================
	class_methods do
		def languages
			[]
		end
	end

end
