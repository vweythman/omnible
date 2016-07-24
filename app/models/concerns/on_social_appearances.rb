# OnSocialAppearances
# ================================================================================
# Extension Method
#
# Methods
# ----------------------------------------
# -- ordered_name_count
# ---- :: returns grouped counts
# ================================================================================

module OnSocialAppearances

	def ordered_name_count
		group("squads.name", "squads.id", "social_appearances.form").count
	end

	def onsite_ordered_name_count
		merge(Work.onsite).ordered_name_count
	end

end
