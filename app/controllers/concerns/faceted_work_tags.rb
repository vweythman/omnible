# FacetedWorkTags Methods
# ================================================================================

module FacetedWorkTags

	# BuildTagList
	# - create the array of hashes
	def map_tags(ids, tag_col)
		ids.map { |i| { tag_col => i } }
	end

	def appearance_map(role, ids)
		ids.map{|i| { character_id: i, role: role} }
	end

	def create_tags
		place_ids = find_place_ids
		
		params[:character][:settings_attributes] = map_tags(place_ids, :place_id)
	end

	def update_tags(model)
		Setting.update_for(model, find_place_ids)

	end

	def find_place_ids
		place_names = params[:places]
		Place.batch_by_name(place_names, current_user)
	end

end
