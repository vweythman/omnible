module CharacterTagged

	# CREATE
	# ............................................................
	# CreateTags
	def create_tags
		# :: find
		related         = ensure_relationship_direction params[:relator]
		identifiers_str = params[:identifiers]
		identity_ids    = find_identity_ids
		character_ids   = find_characters_ids(related)

		# :: set
		params[:character][:identifiers_attributes]  = map_tags(identifiers_str.split(";"), :name)
		params[:character][:descriptions_attributes] = map_tags(identity_ids, :identity_id)
		params[:character][:prejudices_attributes]   = map_prejudice_identities

		params[:character][:left_interconnections_attributes]  = map_relationships(character_ids[:right], :right_id)
		params[:character][:right_interconnections_attributes] = map_relationships(character_ids[:left], :left_id)
	end

	def ensure_relationship_direction(group)
		{ :left => group[:left], :right => group[:right].merge(group[:either])}
	end

	# UPDATE
	# ............................................................
	# SetTags
	def update_tags(model)
		# :: prejudices
		params[:character][:prejudices_attributes] = map_prejudice_identities

		# :: identifiers
		str = params[:identifiers]
		Identifier.update_for(model, str.split(";"))

		# :: identities
		Description.update_for(model, find_identity_ids)

		# :: relationships
		character_ids = find_characters_ids params[:relator]
		Interconnection.update_for(model, character_ids)
	end

	# MAPPERS
	# ............................................................
	# BuildTagList
	# - create the array of hashes
	def map_tags(ids, tag_col)
		ids.map { |i| { tag_col => i } }
	end

	def map_prejudice_identities
		prejudices = params[:character][:prejudices_attributes]

		Identity.transaction do
			prejudices.each do |key, prejudice|
				fid = prejudice[:facet_id].to_i
				inm = prejudice[:identity_name]
				identity = Identity.where(name: inm, facet_id: fid).first_or_create
				prejudices[key][:identity_id] = identity.id
			end
		end unless prejudices.nil?

		prejudices
	end

	def map_relationships(groups, direction_label)
		tags = Array.new
		unless groups.nil?
			groups.map {|relateables|
				relateables[:list].each do |id|
					tags << { :relator_id => relateables[:relator_id].to_i, direction_label => id }
				end
			}
		end
		return tags
	end

	# BATCH FINDERS
	# ............................................................
	def find_identity_ids
		facets = Facet.all
		ids    = Array.new

		Identity.transaction do
			facets.each do |facet|
				identities = Identity.faceted_line_batch(facet.id, params[facet.name], current_user)
				ids += identities.map{ |i| i.id }
			end
		end

		ids
	end

	def find_characters_ids(direction_groups)
		tags  = Hash.new

		Interconnection.transaction do
			direction_groups.map {|direction, relator_groups|
				tags[direction] = Array.new
				relator_groups.map{|relator_id, character_names|
					characters = Character.line_batch_by_name(character_names, current_user)
					ids_list   = characters.map{ |i| i.id }
					tags[direction] << { :relator_id => relator_id, :list => ids_list }
				}
			}
		end

		tags
	end

end
