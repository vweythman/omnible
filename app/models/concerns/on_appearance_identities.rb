# OnAppearanceIdentities
# ================================================================================
# Extension Method
#
# Methods
# ----------------------------------------
# -- ordered_name_count
# ---- :: returns grouped counts
# ================================================================================

module OnAppearanceIdentities

	def ordered_name_count
		group("identities.name", "identities.id", "appearances.role").ordered_count
	end

	def onsite_ordered_name_count
		merge(Work.onsite).ordered_name_count
	end

end
