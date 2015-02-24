class Identity < ActiveRecord::Base
	default_scope {order('facet_id, lower(name)')}

	# ASSOCIATIONS
	belongs_to :facet
	has_many :descriptions
	has_many :characters, through: :descriptions
	accepts_nested_attributes_for :descriptions

	has_many :appearances, source: :appearance, through: :descriptions
	has_many :works, ->{uniq}, source: :work, through: :appearances


	scope :ages, -> { where(facet: 'age') }
	scope :genders, -> { where(facet: 'gender') } 


	def main_title
		"#{facet}: #{name}"
	end

	def self.null_state
		NullIdentity.new
	end

	def self.organized_all
		Identity.organize(Identity.all)
	end

	def self.organize(identities)
		list = Hash.new
		identities.each do |identity|
			if list[identity.facet].nil?
				facet = Hash.new
				facet[:facet]        = identity.facet
				facet[:identities]   = Array.new
				list[identity.facet] = facet
			end
			list[identity.facet][:identities].push(identity)
		end
		return list
	end

	def self.facets()
		Identity.select('facet').group(:facet)
	end
end

class NullIdentity
	def id
		nil
	end

	def main_title
		"Identities"
	end

	def part_of
		:identities
	end
end
