# Character
# ================================================================================
# characters belong to the subject group of tags
#
# Variables (max length: 15 characters) 
# --------------------------------------------------------------------------------
#  variable name   | type        | about
# --------------------------------------------------------------------------------
#  id              | integer     | unique
#  name            | string      | maximum of 250 characters
#  about           | text        | can be null
#  created_at      | datetime    | must be earlier or equal to updated_at
#  updated_at      | datetime    | must be later or equal to created_at
#
# Methods (max length: 25 characters) 
# --------------------------------------------------------------------------------
#  method name                 | output type | description
# --------------------------------------------------------------------------------
#  heading                     | string      | defines the main means of
#                              |             | addressing the model
#  interconnections            | array       | finds both left and right 
#                              |             | interconnections
#  replicate                   | model       | clone character and create 
#                              |             | interconnection between original
#                              |             | and clone
#  is_a_clone?                 | bool        | asks if character cloned from 
#                              |             | another character
#  playable?                   | bool        | asks if character is an roleplay 
#                              |             | character
# ================================================================================

class Character < ActiveRecord::Base

	# MODULES
	# ------------------------------------------------------------
	include Editable
	include Documentable
	include Replicant

	# SCOPES
	# ------------------------------------------------------------
	scope :top_appearers, -> { joins(:appearances).group("characters.id").order("COUNT(appearances.character_id) DESC").limit(10) }
	scope :not_among, ->(character_names) { where("name NOT IN (?)", character_names) }
	scope :are_among, ->(character_names) { where("name IN (?)", character_names) }
	scope :next_in_line, ->(character_name) { where('name > ?', character_name).order('name ASC') }
	scope :prev_in_line, ->(character_name) { where('name < ?', character_name).order('name DESC') }

	# VALIDATIONS
	# ------------------------------------------------------------
	validates :name, length: { maximum: 100 }, presence: true

	# ASSOCIATIONS
	# ------------------------------------------------------------
	# - Joins
	has_many :appearances,  dependent: :destroy
	has_many :descriptions, dependent: :destroy
	has_many :memberships,  dependent: :destroy
	has_many :possessions,  dependent: :destroy

	has_many :reputations, class_name: "Opinion", dependent: :destroy, foreign_key: "recip_id"
	has_many :left_interconnections,  class_name: "Interconnection", dependent: :destroy, foreign_key: "left_id"
	has_many :right_interconnections, class_name: "Interconnection", dependent: :destroy, foreign_key: "right_id"

	# - Belongs to
	has_many :groups, through: :memberships
	has_many :works,  through: :appearances

	# - Has
	has_many :identities,  through: :descriptions
	has_many :items,       through: :possessions

	has_many :identifiers, dependent: :destroy
	has_many :opinions,    dependent: :destroy, :inverse_of => :character
	has_many :prejudices,  dependent: :destroy, :inverse_of => :character

	# - References
	has_many :anthologies, ->{uniq}, :through => :works

	# NESTED ATTRIBUTION
	# ------------------------------------------------------------
	accepts_nested_attributes_for :descriptions, :allow_destroy => true
	accepts_nested_attributes_for :identifiers,  :allow_destroy => true
	accepts_nested_attributes_for :opinions,     :allow_destroy => true
	accepts_nested_attributes_for :possessions,  :allow_destroy => true
	accepts_nested_attributes_for :prejudices,   :allow_destroy => true

	# DEEP DUPLICATION
	# ------------------------------------------------------------
	amoeba do
		enable
		include_association :descriptions
		include_association :identifiers
		include_association :opinions
		include_association :possessions
		include_association :prejudices
	end

	# CLASS METHODS
	# ------------------------------------------------------------
	def self.batch(characters, uploader, column = :character_id)
		Character.transaction do 
			appearing = characters.map { |c| 
				character = Character.where(name: c[:name]).first_or_create
				character.uploader = uploader
				character.save
				c.merge!({column => character.id})
			}
		end
	end

	# METHODS
	# ------------------------------------------------------------
	# Heading
	# - defines the main means of addressing the model
	def heading
		self.name
	end

	# Interconnections
	# - finds both left and right interconnections
	def interconnections
		Interconnection.character_interconnections(self.id).order(:relator_id).includes(:relator, :left, :right)
	end

	# OrderedConnections
	# - organizes the interconnections
	def ordered_connections
		Interconnection.organize(self.interconnections, self)
	end

	# Viewpoints
	# - merge opinions and prejudices
	def viewpoints
		self.prejudices.includes(:identity) + self.opinions.includes(:recip)
	end

	# NextCharacter
	# - find next character alphabetically
	def next_character(user = nil)
		@next_character ||= Character.next_in_line(self.name).viewable_for(user).first
	end

	# NextCharacter
	# - find next character alphabetically
	def prev_character(user = nil)
		@prev_character ||= Character.prev_in_line(self.name).viewable_for(user).first
	end

	# ReputationCount
	# - count how many characters have an opinion about the character
	def reputation_count
		@repcount ||= self.reputations.size
	end

	# Likableness
	# - how well liked is the character
	def likableness
		amt = self.reputation_count
		sum = self.reputations.summarize(:fondness).first

		sum.fondness / amt
	end

	# Respectedness
	# - how well respected is the character
	def respectedness
		amt = self.reputation_count
		sum = self.reputations.summarize(:respect).first

		sum.respect / amt
	end

	# IsPlayableCharacter
	# - asks whether character is a player character
	def is_playable_character?
	end

	# Playable?
	# - asks if character can be cloned for roleplay
	def playable?
		self.allow_play == 't' || self.allow_play == true
	end

end
