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
	# ============================================================
	validates :name,        presence: true, length: { maximum: 250 }
	validates :uploader_id, presence: true

	# MODULES
	# ============================================================
	include Summarizable
	include Editable

	# SCOPES
	# ============================================================
	scope :recently_updated, ->(num) { order(:updated_at => :desc).limit(num) }
	scope :alphabetic,       ->      { order('lower(anthologies.name)') }

	# ASSOCIATIONS
	# ============================================================
	# JOINS
	# ------------------------------------------------------------
	has_many :collections

	# HAS AND BELONGS TO
	# ------------------------------------------------------------
	belongs_to :uploader, class_name: "User"
	has_many   :works,    through: :collections

	# REFERENCES
	# ------------------------------------------------------------
	has_many :tagged_characters, -> {uniq}, through: :works, source: :characters,    extend: OnAppearances
	has_many :tagged_groups,     -> {uniq}, through: :works, source: :social_groups, extend: OnSocialAppearances
	has_many :tagged_tags,       -> {uniq}, through: :works, source: :tags,   extend: OnTaggings
	has_many :tagged_places,     -> {uniq}, through: :works, source: :places, extend: OnSettings
	has_many :tagged_works,      -> {uniq}, through: :works, source: :works,  extend: OnIntrataggings do
		def onsite_ordered_title_count
			where("works_tagged_works_join.type NOT IN (#{WorksTypeDescriber.offsite_sql})").ordered_title_count
		end
	end

	# NESTED ATTRIBUTION
	# ============================================================
	accepts_nested_attributes_for :collections

	# PUBLIC METHODS
	# ============================================================
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
		self.uploader_id == user.id
	end

	def uploader?(user)
		user.present? && self.uploader_id == user.id
	end

end
