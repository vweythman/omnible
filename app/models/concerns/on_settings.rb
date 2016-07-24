# OnSettings
# ================================================================================
# Extension Method
#
# Methods
# ----------------------------------------
# -- ordered_name_count
# ---- :: returns grouped counts
# ================================================================================

module OnSettings

	def onsite_count_by_name
		merge(Work.onsite).count_by_name
	end

end
