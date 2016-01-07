# FacetedWorkTags Methods
# ================================================================================

module FacetedWorkTags

	# BuildTagList
	# - create the array of hashes
	def map_tags(ids, tag_col)
		ids.map { |i| { tag_col => i } }
	end

	def appearance_map(grouped_ids)
		tags = grouped_ids.map{ |role, ids|
			ids.map { |id|
				{ :role => role, character_id: id }
			}
		}
		tags.flatten
	end

	def create_tags(work_type, is_narrative)
		params[work_type][:appearances_attributes] = appearance_map(find_character_ids(is_narrative))
		params[work_type][:settings_attributes]    = map_tags(find_place_ids, :place_id)
		params[work_type][:taggings_attributes]    = map_tags(find_tag_ids,   :tag_id)
	end

	def update_tags(model)
		Setting.update_for(model, find_place_ids)
		Appearance.update_for(model, find_character_ids(model.narrative?))
		Tagging.update_for(model, find_tag_ids)
	end

	def find_place_ids
		place_names = params[:places]
		Place.batch_by_name(place_names, current_user)
	end

	def find_character_ids(is_narrative)
		roles = Appearance.roles_by_type(is_narrative)
		tags  = Hash.new

		Appearance.transaction do
			roles.map {|role| 
				characters_list = Character.line_batch_by_name(params[role], current_user)
				tags[role]      = characters_list.map{ |i| i.id }
			}
		end

		tags
	end

	def find_tag_ids
		tags = Tag.batch_by_name params[:tags]
		tags.map{ |i| i.id }
	end

end
