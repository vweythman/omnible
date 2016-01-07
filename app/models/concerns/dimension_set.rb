class DimensionSet
	def initialize(collected, keys)
		@set = build_set(collected, keys)
	end

	def top_keys
		@set.keys
	end

	def minor_keys(key)
		if @set[key].nil?
			return Array.new
		else
			return @set[key].keys
		end
	end

	def end_values(major_key, minor_key)
		if @set[major_key].nil? || @set[major_key][minor_key].nil?
			Array.new
		else
			@set[major_key][minor_key]
		end
	end

	private
	def build_set(list, keys)
		rset = Hash.new

		list.each do |val|
			major_key = val.seek_by keys[0]
			minor_key = val.seek_by keys[1]
			end_value = val.seek_by keys[2]

			rset[major_key]       = Hash.new if rset[major_key].nil?
			rset[major_key][minor_key] = Array.new if rset[major_key][minor_key].nil?
			rset[major_key][minor_key] << end_value
		end

		rset
	end

end
