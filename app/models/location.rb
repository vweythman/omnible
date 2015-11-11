# Location
# ================================================================================
# join table, tags characters with places
#
# Table Variables
# --------------------------------------------------------------------------------
#  variable     | type           | about
# --------------------------------------------------------------------------------
#  id           | integer        | unique
#  character_id | integer        | references character
#  place_id     | integer        | references place
#  nature       | string         | type
#  created_at   | datetime       | must be earlier or equal to updated_at
#  updated_at   | datetime       | must be later or equal to created_at
# ================================================================================

class Location < ActiveRecord::Base
	belongs_to :character
	belongs_to :place

	def self.relators
		['Genius Loci', 'Personification', 'Birthplace', 'Home', 'School', 'Workplace', 'Resting Place']
	end
end
