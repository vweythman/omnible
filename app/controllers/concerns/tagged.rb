module Tagged

	# BuildTagList
	# - create the array of hashes
	def build_tags(ids, tag_col)
		ids.map { |i| { tag_col => i } }
	end

end