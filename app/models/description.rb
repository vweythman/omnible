class Description < ActiveRecord::Base
	belongs_to :character
	belongs_to :identity

	belongs_to :appearance, foreign_key: :character_id, primary_key: :character_id
end
