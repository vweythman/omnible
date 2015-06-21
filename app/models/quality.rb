class Quality < ActiveRecord::Base

	# MODULES
	# ------------------------------------------------------------
	extend Taggable       # class methods for general tags
	extend FriendlyId     # class methods for clean urls
	include Referenceable # instance methods for general tags

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
	has_many :item_tags

	# belongs to
	has_many :items, :through => :item_tags
	belongs_to :adjective, :inverse_of => :qualities

	# METHODS
	# ------------------------------------------------------------
	# Heading
	# - defines the main means of addressing the model
	def heading
		name
	end

end
