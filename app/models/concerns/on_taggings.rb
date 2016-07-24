# OnTaggings
# ================================================================================
# Extension Method
#
# Methods
# ----------------------------------------
# -- ordered_name_count
# ---- :: returns grouped counts
# ================================================================================

module OnTaggings

	def ordered_name_count
		group("tags.name", "tags.id", "taggings.form").ordered_count
	end

	def onsite_ordered_name_count
		merge(Work.onsite).ordered_name_count
	end

end
