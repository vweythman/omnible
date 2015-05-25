class Quality < ActiveRecord::Base

	# MODULES
	# ------------------------------------------------------------
	include Imaginable    # member of the idea group
	extend Taggable      # member of the tag group
	extend FriendlyId     # slugged based on the name

	# SCOPES
	# ------------------------------------------------------------
	scope :not_among, ->(qualities) { where("name NOT IN (?)", qualities) }
	scope :are_among, ->(qualities) { where("name IN (?)", qualities) }
	
	# VALIDATIONS
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

end
