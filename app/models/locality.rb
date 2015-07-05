class Locality < ActiveRecord::Base
	belongs_to :domain, class_name: "Place"
	belongs_to :subdomain, class_name: "Place"
	
	validates_uniqueness_of :subdomain_id, :scope => :domain_id
	validate :reality_enforcement

	scope :subdomains, ->(domain_ids)    { where("domain_id IN (?)", domain_ids) }
	scope :domains,    ->(subdomain_ids) { where("subdomain_id IN (?)", subdomain_ids) }

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

	def reality_enforcement
		if (self.domain.fictional? && !self.subdomain.fictional?)
			errors.add(:subdomain, "fictitious places cannot be the parent place of real places")
		end
	end

end
