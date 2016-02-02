# Anthology
# ================================================================================
# collection of narrative works
#
# Table Variables
# --------------------------------------------------------------------------------
#  variable        | type        | about
# --------------------------------------------------------------------------------
#  id              | integer     | unique
#  name            | string      | maximum of 250 characters
#  created_at      | datetime    | must be earlier or equal to updated_at
#  updated_at      | datetime    | must be later or equal to created_at
#  summary         | string      | can be null
#  uploader_id     | integer     | references user
# ================================================================================

class Anthology < ActiveRecord::Base
	
	# VALIDATIONS
	# ------------------------------------------------------------
	validates :name, length: { maximum: 250 }, presence: true
	validates :uploader_id, presence: true

	# MODULES
	# ------------------------------------------------------------
	include Summarizable

	# SCOPES
	# ------------------------------------------------------------
	scope :recently_updated, ->(num) { order(:updated_at => :desc).limit(num) }
	scope :alphabetic,       ->      { order('lower(anthologies.name)') }

	# ASSOCIATIONS
	# ------------------------------------------------------------
	has_many   :collections
	belongs_to :uploader, class_name: "User"
	has_many   :works,    :through => :collections

	# NESTED ATTRIBUTION
	# ------------------------------------------------------------
	accepts_nested_attributes_for :collections

	# PUBLIC METHODS
	# ------------------------------------------------------------
	# Heading
	# - defines the main means of addressing the model
	def heading
		self.name
	end

	# JustCreated? - self explanatory
	def just_created?
		self.updated_at == self.created_at
	end

	def editable? user
		self.uploader == user
	end

end
