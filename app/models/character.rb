class Character < ActiveRecord::Base
	# SCOPES
	scope :top_appearers, -> {joins(:appearances).group("characters.id").order("COUNT(appearances.character_id) DESC").limit(10) }

	# RELATED MODELS
	has_many :identifiers
	has_many :viewpoints
	has_many :opinions,   -> { where(recip_type: 'Character') } 
	has_many :prejudices, -> { where(recip_type: 'Identity') } 

	has_many :memberships
	has_many :casts, through: :memberships

	has_many :appearances
	has_many :works, through: :appearances

	has_many :descriptions
	has_many :identities, through: :descriptions
	has_many :left_relationships, class_name: "Relationship", foreign_key: "left_id"
	has_many :right_relationships, class_name: "Relationship", foreign_key: "right_id"
	
	accepts_nested_attributes_for :identifiers
	accepts_nested_attributes_for :opinions
	accepts_nested_attributes_for :prejudices
	accepts_nested_attributes_for :descriptions
	accepts_nested_attributes_for :left_relationships
	accepts_nested_attributes_for :right_relationships

	# Other Class Variables
	def main_title
		name
	end

	def relationships
		left_relationships + right_relationships
	end

	def canon_relationships
		if @canon_relationships.nil?
			@canon_relationships = Relationship.where('right_id= ? OR left_id= ?', id, id).where(canon: '1')
		else
			@canon_relationships
		end
	end

	def noncanon_relationships
		if @noncanon_relationships.nil?
			@noncanon_relationships = Relationship.where('right_id= ? OR left_id= ?', id, id).where(canon: '0')
		else
			@noncanon_relationships
		end
	end

	def self.null_state
		NullCharacter.new
	end
end

class NullCharacter
	def main_title
		"Characters"
	end

	def part_of
		:characters
	end

	def id
		nil
	end
end
