# Nonfiction
# ================================================================================
# type of non-narrative work
# see Work for table variables

class Nonfiction < Work

	def self.with_filters(options, user)
		Work.nonfiction.with_filters(options, user)
	end
end
