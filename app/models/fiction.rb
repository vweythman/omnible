# Fiction
# ================================================================================
# type of narrative work
# see Work for table variables

class Fiction < Work

	def self.with_filters(options, user)
		Work.fiction.with_filters(options, user)
	end

end
