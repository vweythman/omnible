# Character
# ================================================================================
# a type of subject
#
# Table Variables
# --------------------------------------------------------------------------------
#  variable        | type        | about
# --------------------------------------------------------------------------------
#  id              | integer     | unique
#  name            | string      | maximum of 250 characters
#  about           | text        | can be null
#  created_at      | datetime    | must be earlier or equal to updated_at
#  updated_at      | datetime    | must be later or equal to created_at
#  uploader_id     | integer     | references user
#  publicity_level | integer     | cannot be null
#  editor_level    | integer     | cannot be null
#  allow_play      | boolean     | cannot be null
#  allow_clones    | boolean     | cannot be null
#  allow_as_clone  | boolean     | cannot be null
#  can_connect     | boolean     | cannot be null
#  is_fictional    | boolean     | default: true
# ================================================================================

class Character < ActiveRecord::Base

	# VALIDATIONS
	# ------------------------------------------------------------
	validates :name, length: { maximum: 100 }, presence: true

	# CALLBACKS
	# ------------------------------------------------------------
	before_create :ensure_defaults
	after_save    :add_tags

	# MODULES
	# ------------------------------------------------------------
	include Editable
	include Documentable
	include Replicant

	# SCOPES
	# ------------------------------------------------------------
	# - General
	scope :are_among, ->(character_names) { where("name IN (?)", character_names) }
	scope :not_among, ->(character_names) { where("name NOT IN (?)", character_names) }

	# - Specific Through Associations
	scope :not_pen_name,   -> { where('characters.id NOT IN (?)', Pseudonyming.pen_namings.pluck(:character_id)) }
	scope :not_roleplayed, -> { where('characters.id NOT IN (?)', Pseudonyming.roleplays.pluck(:character_id)) }
	scope :top_appearers,  -> { joins(:appearances).group("characters.id").order("COUNT(appearances.character_id) DESC").limit(10) }

	# - Related Characters
	scope :next_in_line, ->(character_name) { where('name > ?', character_name).order('name ASC') }
	scope :prev_in_line, ->(character_name) { where('name < ?', character_name).order('name DESC') }

	# ASSOCIATIONS
	# ------------------------------------------------------------
	# - Joins
	has_one  :pseudonyming, dependent: :destroy
	has_many :appearances,  dependent: :destroy
	has_many :descriptions, dependent: :destroy
	has_many :memberships,  dependent: :destroy
	has_many :possessions,  dependent: :destroy

	has_many :main_appearances,    -> { Appearance.main }
	has_many :mentions,            -> { Appearance.mentioned }
	has_many :side_appearances,    -> { Appearance.side }
	has_many :subject_appearances, -> { Appearance.subject }

	has_many :reputations,            class_name: "Opinion",         dependent: :destroy, foreign_key: "recip_id"
	has_many :left_interconnections,  class_name: "Interconnection", dependent: :destroy, foreign_key: "left_id"
	has_many :right_interconnections, class_name: "Interconnection", dependent: :destroy, foreign_key: "right_id"

	has_one :pseudonyming
	has_one :pen_naming, ->{ Pseudonyming.pen_namings }, class_name: "Pseudonyming"
	has_one :roleplay,   ->{ Pseudonyming.roleplays },   class_name: "Pseudonyming"

	# - Belongs to
	has_one  :creator,    through: :pen_naming, source: :user
	has_one  :roleplayer, through: :roleplay,   source: :user

	has_many :groups,     through: :memberships
	has_many :works,      through: :appearances

	has_many :main_in,      through: :main_appearances
	has_many :mentioned_in, through: :mentions
	has_many :side_in,      through: :side_appearances
	has_many :subject_in,   through: :subject_appearances

	# - Has
	has_many :details, dependent: :destroy, class_name: "CharacterInfo"
	has_many :identities, through: :descriptions
	has_many :items,      through: :possessions

	has_many :identifiers, dependent: :destroy
	has_many :opinions,    dependent: :destroy, :inverse_of => :character
	has_many :prejudices,  dependent: :destroy, :inverse_of => :character

	# - References
	has_many :anthologies, ->{uniq}, :through => :works

	# NESTED ATTRIBUTION
	# ------------------------------------------------------------
	accepts_nested_attributes_for :descriptions, :allow_destroy => true
	accepts_nested_attributes_for :details,      :allow_destroy => true
	accepts_nested_attributes_for :identifiers,  :allow_destroy => true
	accepts_nested_attributes_for :opinions,     :allow_destroy => true
	accepts_nested_attributes_for :possessions,  :allow_destroy => true
	accepts_nested_attributes_for :prejudices,   :allow_destroy => true
	accepts_nested_attributes_for :left_interconnections,  :allow_destroy => true
	accepts_nested_attributes_for :right_interconnections, :allow_destroy => true

	# DEEP DUPLICATION
	# ------------------------------------------------------------
	amoeba do
		enable
		include_association :descriptions
		include_association :identifiers
		include_association :opinions
		include_association :possessions
		include_association :prejudices
		include_association :left_interconnections
		include_association :right_interconnections
	end

	# CLASS METHODS
	# ------------------------------------------------------------
	def self.batch_by_name(names, uploader)
		Character.transaction do 
			names.split(";").map { |name| 
				name.strip!
				character = Character.where(name: name).first_or_create
				character.uploader_id ||= uploader.id
				character.save
				character
			}
		end
	end

	def self.batch_each_person(names, uploader)
		Character.transaction do 
			names.split(";").map { |name| 
				name.strip!
				character = Character.where(name: name).first_or_create
				character.uploader_id  ||= uploader.id
				character.is_fictional ||= false
				character.save
				character
			}
		end
	end

	# ATTRIBUTES
	# ------------------------------------------------------------
	attr_accessor :visitor, :variations, :describers, :related

	# PUBLIC METHODS
	# ------------------------------------------------------------
	# Heading - defines the main means of addressing the model
	def heading
		self.name
	end
	
	def relation_set(use_id = true)
		@relation_set ||= build_relation_set(use_id)
	end

	def get_rrset(relator_id)
		relation_set.end_values(relator_id, self.id)
	end

	def get_lrset(relator_id)
		relation_set.minor_keys(relator_id)
	end

	# GETTERS
	# ............................................................
	# Interconnections - finds both left and right interconnections
	def interconnections
		Interconnection.relations_for(self.id).order(:relator_id).includes(:relator, :left, :right)
	end

	# NextCharacter - find next character alphabetically
	def next_character(user = nil)
		@next_character ||= Character.next_in_line(self.name).viewable_for(user).first
	end

	# NextCharacter - find next character alphabetically
	def prev_character(user = nil)
		@prev_character ||= Character.prev_in_line(self.name).viewable_for(user).first
	end

	def other_characters
		Character.not_among([self])
	end

	# CALC
	# ............................................................
	# ReputationCount - count how many characters have an opinion about the character
	def reputation_count
		@repcount ||= self.reputations.size
	end

	# AverageReputation - how well liked and well respected this character is
	def average_reputation
		reputations.aggreate_average.first
	end

	# AvgerageLikes - how well liked is the character
	def avgerage_likes
		amt = self.reputation_count
		sum = self.reputations.summarize(:fondness).first

		(sum.fondness / amt).round
	end

	# AvgerageRespect - how well respected is the character
	def avgerage_respect
		amt = self.reputation_count
		sum = self.reputations.summarize(:respect).first

		(sum.respect / amt).round
	end

	# QUESTIONS
	# ............................................................
	def connectable?(user)
		self.can_connect || self.uploader_id = user.id
	end

	# IsPlayableCharacter - asks whether character is a player character
	def is_playable_character?
		!self.roleplayer.nil?
	end

	# Playable? - asks if character can be cloned for roleplay
	def playable?
		self.allow_play == true
	end

	def fictitious_person?
		self.is_fictional == true
	end

	def has_about?
		self.interconnections.length > 0 || self.details.length > 0
	end

	# PRIVATE METHODS
	# ------------------------------------------------------------
	private

	# EnsureDefaults - default behaivor
	def ensure_defaults
		self.allow_play ||= true

		self.allow_clones   ||= true
		self.allow_as_clone ||= true

		self.editor_level    ||= Editable::PRIVATE
		self.publicity_level ||= Editable::PUBLIC
	end

	def build_relation_set(use_id)
		if use_id
			DimensionSet.new(Interconnection.relations_for(self.id).simple_order, [:relator_id, :left_id, :right_id])
		else
			DimensionSet.new(Interconnection.relations_for(self.id).simple_order.includes(:left, :right), [:relator_id, :left_name, :right_name])
		end
	end

	def add_tags
		Identifier.update_for(self, @variations.split(";"))  unless @variations.nil?
		Description.update_for(self, @describers, @visitor)  unless @describers.nil?
		Interconnection.update_for(self, @related, @visitor) unless @related.nil?
	end

	def variations
		@variations ||= ""
	end

	def describers
		@describers ||= []
	end

end
