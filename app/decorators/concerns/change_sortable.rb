module ChangeSortable

	def sort_by_update
		w = Hash.new
		dates.map { |t| 
			w[t] = self.select{|x| h.record_time(x.updated_at) == t}
		}

		return w
	end

	def dates
		self.map { |x| h.record_time x.updated_at }.uniq
	end

end
