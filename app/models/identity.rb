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
		"#{facet.name}: #{name}"
	end

	def facet_name
		facet.name unless facet.nil?
	end

	def self.null_state
		NullIdentity.new
	end

	def self.organized_all(list = Identity.includes(:facet))
		Identity.organize(list)
	end

	def self.organize(identities)
		list = Hash.new
		identities.each do |identity|
			list[identity.facet.name] = Array.new if list[identity.facet.name].nil?
			list[identity.facet.name].push(identity)
		end
		list.sort!
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
