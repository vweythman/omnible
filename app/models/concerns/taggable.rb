# Taggable Methods
# ================================================================================
# class methods for models that can act as tags for other models
# 
# Questions
# output type is always true or false - boolean
# --------------------------------------------------------------------------------
#  method name                 | description
# --------------------------------------------------------------------------------
#  is_subject?                 | answers that model is not a subject
#
# Lists
# output type is a collection of other types - arrays, lists, hashes
# --------------------------------------------------------------------------------
#  method name                 | description
# --------------------------------------------------------------------------------
#  hash_list                   | create the array of hashes
#  batch                       | creates a group of tags that don't already exist
# ================================================================================

module Taggable

	def self.included(base)
		base.extend ClassMethods
	end

	# IsSubject?
	# - answers that model is not a subject
	def is_subject?
		false
	end

	# Linkable
	# - grab what will be used when organizing
	def linkable
		self
	end

	module ClassMethods

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
		# - creates tags from list unless they already exist
		def batch(tagsline)
			taggables = tagsline.split(";")
			oldTags = self.are_among(taggables).pluck(:name)
			newTags = self.hash_list(taggables - oldTags, :name)
			self.create(newTags)
		end
	end
end
