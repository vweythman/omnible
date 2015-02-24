class Description < ActiveRecord::Base
	belongs_to :character
	belongs_to :identity
	has_one :facet, through: :identity

	def facet_id
		facet.id unless identity.nil?
	end

	belongs_to :appearance, foreign_key: :character_id, primary_key: :character_id
end
