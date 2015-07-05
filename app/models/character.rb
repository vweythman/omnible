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
#  interconnections                 | array       | finds both left and right 
#                              |             | interconnections
#  replicate                   | model       | clone character and create 
#                              |             | interconnection between original and 
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
	include Documentable

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
	# joins
	has_many :appearances,  dependent: :destroy
	has_many :descriptions, dependent: :destroy
	has_many :memberships,  dependent: :destroy
	has_many :possessions,  dependent: :destroy
	has_many :replications, dependent: :destroy, foreign_key: "original_id"

	has_one  :cloning,     class_name: "Replication", dependent: :destroy, foreign_key: "clone_id"
	has_many :reputations, class_name: "Opinion",     dependent: :destroy, foreign_key: "recip_id"
	has_many :left_interconnections,  class_name: "Interconnection", dependent: :destroy, foreign_key: "left_id"
	has_many :right_interconnections, class_name: "Interconnection", dependent: :destroy, foreign_key: "right_id"

	# models that possess these models
	has_many   :groups,   through: :memberships
	has_many   :works,    through: :appearances
	has_one    :original, through: :cloning
	belongs_to :uploader, class_name: "User"

	# models that belong to this model
	has_many :clones,      through: :replications
	has_many :identities,  through: :descriptions
	has_many :items,       through: :possessions

	has_many :identifiers, dependent: :destroy
	has_many :opinions,    dependent: :destroy
	has_many :prejudices,  dependent: :destroy

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
		include_association :opinions
		include_association :prejudices
		include_association :identifiers
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

	# Replicate
	# - clone character and create interconnection between original and clone
	def replicate(current_user)
		replication = Replication.new
		replica     = self.amoeba_dup
		number      = self.clones.count + 1
		
		replica.name     = "#{replica.name} (Clone \##{number})"
		replica.uploader = current_user

		replication.original = self
		replication.clone    = replica

		replication.save

		return replica
	end

	# NextCharacter
	# - find next character alphabetically
	def next_character
		@next_character ||= Character.next_in_line(self.name).first
	end

	# NextCharacter
	# - find next character alphabetically
	def prev_character
		@prev_character ||= Character.prev_in_line(self.name).first
	end

	# ReputationCount
	# - 
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

	# Editable?
	# - asks if character can be edited
	def editable?(user)
		self.editor_level > 1 || self.uploader == user
	end

	# CanBeAClone?
	# - asks if character can be set as a clone
	def can_be_a_clone?
		self.allow_as_clone == 't'
	end

	# Cloneable?
	# - asks whether character can be cloned
	def cloneable?
		self.allow_clones == 't'
	end

	# IsAClone?
	# - asks if character cloned from another character
	def is_a_clone?
		self.original.present?
	end

	# IsPlayableCharacter
	# - asks whether character is a player character
	def is_playable_character?
	end

	# Playable?
	# - asks if character can be cloned for roleplay
	def playable?
		self.allow_play == 't'
	end

	# Viewable?
	# - asks if character is publically viewable or owned by 
	#   current user
	def viewable?(user)
		self.publicity_level > 2 || 
	end

	def self.publicity_levels
		['private', 'friends', 'followers', 'public']
	end

	def self.editor_levels
		['private', 'invited', 'public']
	end

end
