# Locality
# ================================================================================
# join table, places contain places within them
#
# Table Variables
# --------------------------------------------------------------------------------
#  variable     | type           | about
# --------------------------------------------------------------------------------
#  id           | integer        | unique
#  domain_id    | integer        | references place
#  subdomain_id | integer        | references place
#  created_at   | datetime       | must be earlier or equal to updated_at
#  updated_at   | datetime       | must be later or equal to created_at
# ================================================================================

class Locality < ActiveRecord::Base

	# VALIDATIONS
	# ------------------------------------------------------------
	validates_uniqueness_of :subdomain_id, :scope => :domain_id

	# SCOPES
	# ------------------------------------------------------------
	scope :subdomains, ->(domain_ids)    { where("domain_id IN (?)", domain_ids) }
	scope :domains,    ->(subdomain_ids) { where("subdomain_id IN (?)", subdomain_ids) }

	# ASSOCIATIONS
	# ------------------------------------------------------------
	belongs_to :domain,    class_name: "Place"
	belongs_to :subdomain, class_name: "Place"
	
	# CLASS METHODS
	# ------------------------------------------------------------
	# BatchMissing - add 
	def self.batch_missing(place)
		place_domains    = place.domains.pluck(:id)
		place_subdomains = place.subdomains.pluck(:id)

		upper = Locality.domains(place_domains).pluck(:domain_id) + [place.id] + place_domains
		lower = Locality.subdomains(place_subdomains).pluck(:subdomain_id) + [place.id] + place_subdomains

		inserts = []

		upper.map { |domain_id|
			curr_subdomains = Locality.subdomains([domain_id]).pluck(:subdomain_id) 
			miss_subdomains = lower - curr_subdomains
			miss_subdomains.map { |subdomain_id|
				if domain_id != subdomain_id
					value = Hash.new
					value[:domain_id]    = domain_id
					value[:subdomain_id] = subdomain_id
					inserts.push value
				end
			}
		}

		Locality.create inserts
	end

end
