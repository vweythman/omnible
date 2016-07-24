# OnIntrataggings
# ================================================================================
# Extension Method
#
# Methods
# ----------------------------------------
# -- ordered_title_count
# ---- :: returns grouped counts
# ================================================================================

module OnIntrataggings

	def ordered_title_count
		group("works.title", "works.id", "work_connections.nature").count
	end

end
