# ================================================================================
# Lists
# --------------------------------------------------------------------------------
#  method name                 | description
# --------------------------------------------------------------------------------
#  hash_list                   | create the array of hashes
#  batch                       | creates a group of tags that don't already exist
# ================================================================================

module NameBatchable

	# METHODS
	# ------------------------------------------------------------
	# HashList
	# - create the array of hashes
	def hash_list(ids, column)
		ids.map { |i| { column => i } }
	end

	# Batch
	# - creates tags from list unless they already exist
	def batch(tagsline)
		taggables = tagsline.split(";")
		oldTags = self.are_among(taggables).pluck(:name, :id)
		newTags = self.hash_list(taggables - oldTags.map{|i| i[0]}, :name)
		created = self.create(newTags)
		created.map(&:id) + oldTags.map{|i| i[1]}
	end
end
