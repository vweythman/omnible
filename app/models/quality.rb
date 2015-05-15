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

	# belongs to
	has_many :items, :through => :item_descriptions
	belongs_to :adjective, :inverse_of => :qualities

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

		taggables.each do |description|
			quality  = Quality.where(name: description).first_or_create
			ids.push quality.id
		end

		ids
	end
end
