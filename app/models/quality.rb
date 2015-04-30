class Quality < ActiveRecord::Base

	# MODULES
	# ------------------------------------------------------------
	include Imaginable    # member of the idea group
	include Taggable      # member of the tag group
	extend FriendlyId     # slugged based on the name
	
	# VALIDATIONS and SCOPES
	# ------------------------------------------------------------
	validates :name, presence: true
	
	# NONTABLE VARIABLES
	# ------------------------------------------------------------
	friendly_id :name, :use => :slugged

	# ASSOCIATIONS
	# ------------------------------------------------------------
	# joins
	has_many :item_descriptions
	has_many :adjectivations

	# belongs to
	has_many :items, :through => :item_descriptions

	# posseses
	has_many :adjectives, :through => :adjectivations

	# NESTED ATTRIBUTION
	# ------------------------------------------------------------
	accepts_nested_attributes_for :adjectivations, :allow_destroy => true

	# METHODS
	# ------------------------------------------------------------
	# Heading
	# - defines the main means of addressing the model
	def heading
		name
	end

	# CLASS METHODS
	# ------------------------------------------------------------
	def self.batch_build(taggables)
		ids = Array.new

		taggables.split(";").each do |description|
			quality  = Quality.where(name: description).first_or_create
			ids.push quality.id
		end

		ids
	end
end
