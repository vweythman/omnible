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
#  connections                 | array       | finds both left and right 
#                              |             | connections
#  replicate                   | model       | clone character and create 
#                              |             | connection between original and 
#                              |             | clone
#  editable?                   | bool        | asks if character can be edited
#  is_a_clone?                 | bool        | asks if character cloned from 
#                              |             | another character
#  playable?                   | bool        | asks if character is an roleplay 
#                              |             | character
#  viewable?                   | bool        | asks if character is publically 
#                              |             | viewable or owned by current user
# ================================================================================

class Character < ActiveRecord::Base

	# MODULES
	# ------------------------------------------------------------
	include Documentable  # member of the subject group

	# SCOPES
	# ------------------------------------------------------------
	scope :top_appearers, -> {joins(:appearances).group("characters.id").order("COUNT(appearances.character_id) DESC").limit(10) }
	scope :not_among, ->(character_names) { where("name NOT IN (?)", character_names) }
	scope :are_among, ->(character_names) { where("name IN (?)", character_names) }
	scope :next_in_line, ->(character_name) { where('name > ?', character_name).order('name ASC') }
	scope :prev_in_line, ->(character_name) { where('name < ?', character_name).order('name DESC') }

	# VALIDATIONS
	# ------------------------------------------------------------
	validates :name, presence: true

	# ASSOCIATIONS
	# ------------------------------------------------------------
	# joins
	has_many :appearances,  dependent: :destroy
	has_many :descriptions, dependent: :destroy
	has_many :memberships,  dependent: :destroy
	has_many :possessions,  dependent: :destroy
	has_many :replications, foreign_key: "original_id", dependent: :destroy
	has_many :viewpoints, dependent: :destroy

	# joins with changed model names
	has_one  :cloning,           class_name: "Replication", foreign_key: "clone_id", dependent: :destroy
	has_many :reputations,       class_name: "Viewpoint",  as: :recip, dependent: :destroy
	has_many :left_connections,  class_name: "Connection",  foreign_key: "left_id",  dependent: :destroy
	has_many :right_connections, class_name: "Connection",  foreign_key: "right_id", dependent: :destroy

	# models that possess these models
	has_many :groups,   through: :memberships
	has_many :works,    through: :appearances
	has_one  :original, through: :cloning

	# models that belong to this model
	has_many :identifiers, dependent: :destroy
	has_many :identities, through: :descriptions
	has_many :items,      through: :possessions
	has_many :clones,     through: :replications

	# subgroups
	has_many :opinions,   -> { where(recip_type: 'Character') } 
	has_many :prejudices, -> { where(recip_type: 'Identity')  }

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
		include_association :possessions
		include_association :viewpoints
		include_association :identifiers
	end

	# METHODS
	# ------------------------------------------------------------
	# Heading
	# - defines the main means of addressing the model
	def heading
		name
	end

	# Connections
	# - finds both left and right connections
	def connections
		Connection.character_connections(self.id).order(:relator_id).includes(:relator)
	end

	# Replicate
	# - clone character and create connection between original and clone
	def replicate
		replica      = self.amoeba_dup
		number       = self.clones.count + 1
		replica.name = "#{replica.name} (Clone \##{number})"

		replica.save

		Replication.create(original_id: self.id, clone_id: replica.id)
		return replica
	end

	def next_character
		@next_character.nil? ? @next_character = Character.next_in_line(self.name).first : @next_character
	end

	def prev_character
		@prev_character.nil? ? @prev_character = Character.prev_in_line(self.name).first : @prev_character
	end

	def judgers
		@judgers = @judgers.nil? ? self.reputations : @judgers
	end

	def likableness
		amt = self.judgers.length
		sum = self.reputations.summed_likes.first

		sum.warmth / amt
	end

	def respectedness
		amt = self.judgers.length
		sum = self.reputations.summed_respects.first

		sum.respect / amt
	end

	# Editable?
	# - asks if character can be edited
	def editable?
	end

	# IsAClone?
	# - asks if character cloned from another character
	def is_a_clone?
		self.original.present?
	end

	# Playable?
	# - asks if character is an roleplay character
	def playable?
	end

	# Viewable?
	# - asks if character is publically viewable or owned by 
	#   current user
	def viewable?
	end

end
