# Possession
# ================================================================================
# join table, tags characters with items
#
# Table Variables
# --------------------------------------------------------------------------------
#  variable        | type        | about
# --------------------------------------------------------------------------------
#  id              | integer     | unique
#  character_id    | integer     | references character
#  item_id         | integer     | references item
#  created_at      | datetime    | must be earlier or equal to updated_at
#  updated_at      | datetime    | must be later or equal to created_at
#  nature          | string      | 
# ================================================================================

class Possession < ActiveRecord::Base

	# ASSOCIATIONS
	# ------------------------------------------------------------
	belongs_to :character
	belongs_to :item
	has_one :generic, through: :item

	# CLASS METHODS
	# ------------------------------------------------------------
	# Types
	def self.types
		['Owns', 'Creates', 'Destroys', 'Guards', 'Endangered by']
	end

	def self.inverses
		{
			"Owns" => "Possession of",
			"Creates" => "Creation of",
			"Destroys" => "Destroyed by",
			"Guards" => "Guarded by",
			"Endangered by" => "Endangers"
		}
	end

	# Organize - list of possessions organized first by relationship and then by type of item
	def self.organize_items(models = Possession.includes(:item, :generic))
		if models.nil?
			return {}
		end
		list = Hash.new
		models.map { |possession|
			unless possession.nil?
				pos_type = possession.nature
				itm_type = possession.item.generic.name

				list[pos_type]           = Hash.new if list[pos_type].nil?
				list[pos_type][itm_type] = Array.new if list[pos_type][itm_type].nil?
				list[pos_type][itm_type] << possession.item
			end
		}
		return list
	end

	def self.organize_characters(models = Possession.includes(:character))
		if models.nil?
			return {}
		end
		list = Hash.new

		models.map { |possession|
			unless possession.nil?
				pos_type = Possession.inverses[possession.nature]
				list[pos_type] = Array.new if list[pos_type].nil?
				list[pos_type] << possession.character
			end
		}
		return list
	end

end
