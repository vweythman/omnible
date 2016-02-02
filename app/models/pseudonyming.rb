# Pseudonyming
# ================================================================================
# join table
#
# Table Variables
# --------------------------------------------------------------------------------
#  variable     | type           | about
# --------------------------------------------------------------------------------
#  id           | integer        | unique
#  user_id      | integer        | references user
#  character_id | integer        | references character
#  created_at   | datetime       | <= updated_at
#  updated_at   | datetime       | >= created_at
#  type         | string         | sti
#  is_primary   | boolean        | default: false
# ================================================================================

class Pseudonyming < ActiveRecord::Base

	# SCOPES
	# ------------------------------------------------------------
	scope :pen_namings, -> { where(:type => "PenNaming") }
	scope :roleplays,   -> { where(:type => "Roleplay")  }
	scope :prime,       -> { where(:is_primary => true)  }

	# ASSOCIATIONS
	# ------------------------------------------------------------
	belongs_to :user
	belongs_to :character,          dependent: :destroy
	has_many   :creatorships,       primary_key: "character_id", foreign_key: "creator_id"
	has_many   :creator_categories, through: :creatorships

	# NESTED ATTRIBUTION
	# ------------------------------------------------------------
	accepts_nested_attributes_for :character
	
	# DELEGATED METHODS
	# ------------------------------------------------------------
	delegate :name, to: :character
	delegate :editable?, to: :character

	# CLASS METHODS
	# ------------------------------------------------------------
	def self.prime_nym
		self.prime.first
	end

	def self.prime_character
		prime_nym.character
	end

	# PUBLIC METHODS
	# ------------------------------------------------------------
	def set_uploader
		self.character.uploader_id = self.user.id
		self.character.save
	end

	def prime?
		self.is_primary == 't' || self.is_primary == true
	end

	def toggle_prime
		self.is_primary = !self.is_primary
	end

	def heading
		name
	end

end
