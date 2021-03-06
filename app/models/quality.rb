# Quality
# ================================================================================
# tags for items
#
# Table Variables
# --------------------------------------------------------------------------------
#  variable name   | type        | about
# --------------------------------------------------------------------------------
#  id              | integer     | unique
#  name            | string      | maximum of 250 characters
#  slug            | string      | used for friendly url
#  created_at      | datetime    | must be earlier or equal to updated_at
#  updated_at      | datetime    | must be later or equal to created_at
#  adjective_id    | integer     | references adjective
# ================================================================================

class Quality < ActiveRecord::Base

	# VALIDATIONS
	# ------------------------------------------------------------
	validates :name, presence: true
	
	# MODULES
	# ------------------------------------------------------------
	extend FriendlyId
	include EditableTag
	include Taggable

	# SCOPES
	# ------------------------------------------------------------
	scope :not_among, ->(qualities) { where("name NOT IN (?)", qualities) }
	scope :are_among, ->(qualities) { where("name IN (?)", qualities) }
	
	# NONTABLE VARIABLES
	# ------------------------------------------------------------
	friendly_id :name, :use => :slugged

	# ASSOCIATIONS
	# ------------------------------------------------------------
	# - Joins
	has_many :item_tags

	# - Belongs to
	has_many   :items,     :through    => :item_tags
	belongs_to :adjective, :inverse_of => :qualities

	# CLASS METHODS
	# ------------------------------------------------------------
	def self.batch_by_name(str)
		names = str.split(";")
		list  = Array.new

		self.transaction do 
			names.map { |name| 
				name.strip!
				model = self.where(name: name).first_or_create
				model.save
				list << model
			}
		end

		return list
	end

	# PUBLIC METHODS
	# ------------------------------------------------------------
	# Heading - defines the main means of addressing the model
	def heading
		name
	end
	
	def editable? user
		user.staffer?
	end

end
