module Tagged

	# BuildTagList
	# - create the array of ids
	def build_tag_list(ids, col)
		arr = Array.new

		ids.each do |i|
			item = Hash.new
			item[col] = i
			arr.push item
		end

		return arr
	end

end