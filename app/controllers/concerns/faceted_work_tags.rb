# FacetedWorkTags Methods
# ================================================================================

module FacetedWorkTags

	# BuildTagList
	# - create the array of hashes
	def map_tags(ids, tag_col)
		ids.map { |i| { tag_col => i } }
	end

	def appearance_map(grouped_ids)
		tags = Array.new
		grouped_ids.map{ |role, ids|
			ids.each do |id|
				tags << { :role => role, character_id: id }
			end
		}
		return tags
	end

	def create_tags(work_type, is_narrative)
		place_ids = find_place_ids

		params[work_type][:settings_attributes]   = map_tags(place_ids, :place_id)
		params[work_type][:appearance_attributes] = appearance_map(find_characters_ids(is_narrative))
	end

	def update_tags(model)
		Setting.update_for(model, find_place_ids)
		Appearance.update_for(model, find_characters_ids(model.narrative?))
	end

	def find_place_ids
		place_names = params[:places]
		Place.batch_by_name(place_names, current_user)
	end

	def find_characters_ids(is_narrative)
		roles = Appearance.roles_by_type(is_narrative)
		tags  = Hash.new

		Appearance.transaction do
			roles.map {|role| tags[role] = Character.batch_by_name(params[role], current_user) }
		end

		tags
	end

end
