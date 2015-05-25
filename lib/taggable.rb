module Taggable

	# HashList
	# - create the array of hashes
	def hash_list(ids, column)
		arr = Array.new

		ids.each do |i|
			item = Hash.new
			item[column] = i
			arr.push item
		end

		return arr
	end

	def batch(tagsline)
		taggables = tagsline.split(";")
		oldTags = self.are_among(taggables).pluck(:name)
		newTags = self.hash_list(taggables - oldTags, :name)
		self.create(newTags)
		self.where(name: taggables).pluck(:id)
	end

end