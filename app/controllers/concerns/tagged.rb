module Tagged

	# BuildTagList
	# - create the array of hashes
	def build_tags(ids, tag_col)
		arr = Array.new

		ids.each do |i|
			item = Hash.new
			item[tag_col] = i
			arr.push item
		end

		return arr
	end

	def build_poly_tags(ids, id_type)
		arr = Array.new

		ids.each do |i|
			item = Hash.new
			item[:tag_id]   = i
			item[:tag_type] = id_type
			arr.push item
		end

		return arr
	end

end