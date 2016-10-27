module FilteringTaggings
	# CHECK
	def searchable_hash taggings
		((taggings.is_a? Hash) && !(taggings.values.reject { |v| v.empty? }.empty?))
	end

	def searchable_string(taggings)
		((taggings.is_a? String) && !(taggings.empty?))
	end

	# ORDERED
	def with_ordered(taggings)
		where("works.id IN (#{WorkConnection.tagger_intersection_sql(taggings)})")
	end

	def without_ordered(taggings)
		where("works.id NOT IN (#{WorkConnection.tagger_intersection_sql(taggings)})")
	end

	# UNSORTED
	def with_unordered(titles)
		where("works.id IN (#{WorkConnection.tagger_with_works(titles).to_sql})")
	end

	def without_unordered(titles)
		where("works.id NOT IN (#{WorkConnection.tagger_with_works(titles).to_sql})")
	end
end
