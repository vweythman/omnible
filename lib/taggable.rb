# Taggable Methods
# ================================================================================
# methods for models that can act as general tags for other models
# 
# Lists
# output type is a collection of other types - arrays, lists, hashes
# --------------------------------------------------------------------------------
#  method name                 | description
# --------------------------------------------------------------------------------
#  hash_list                   | create the array of hashes
#  batch                       | creates a group of tags that don't already exist
#
# Questions
# output type is always true or false - boolean
# --------------------------------------------------------------------------------
#  method name                 | description
# --------------------------------------------------------------------------------
#  is_subject?                 | answers that model is not a subject
# ================================================================================

module Taggable

	# LISTS
	# ------------------------------------------------------------
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

	# Batch
	# - creates a group of tags that don't already exist
	def batch(tagsline)
		taggables = tagsline.split(";")
		oldTags = self.are_among(taggables).pluck(:name)
		newTags = self.hash_list(taggables - oldTags, :name)
		self.create(newTags)
	end

	# QUESTIONS
	# ------------------------------------------------------------
	# IsSubject?
	# - answers that model is not a subject
	def is_subject?
		false
	end

end