# IdentityTagged Methods
# ================================================================================

module IdentityTagged

	# BuildTagList
	# - create the array of hashes
	def map_tags(ids, tag_col)
		ids.map { |i| { tag_col => i } }
	end

	# CREATE
	# ............................................................
	# CreateTags
	def create_tags
		str          = params[:identifiers]
		identity_ids = find_identity_ids

		params[:character][:identifiers_attributes]  = map_tags(str.split(";"), :name)
		params[:character][:descriptions_attributes] = map_tags(identity_ids, :identity_id)
	end

	# UPDATE
	# ............................................................
	# SetTags
	def update_tags(model)
		# :: identifiers
		str = params[:identifiers]
		Identifier.update_for(model, str.split(";"))

		# :: identities
		Description.update_for(model, find_identity_ids)
	end

	def find_identity_ids
		facets = Facet.all
		ids    = Array.new

		Identity.transaction do
			facets.each do |facet|

				str   = params[facet.name]
				names = str.split(";")

				names.each do |name|
					name.strip!
					identity = Identity.where(name: name, facet_id: facet.id).first_or_create
					ids << identity.id
				end
			end
		end

		ids
	end

end
