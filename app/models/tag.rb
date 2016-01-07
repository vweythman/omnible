# Tag
# ================================================================================
# tags are used for works
#
# Table Variables
# --------------------------------------------------------------------------------
#  variable     | type           | about
# --------------------------------------------------------------------------------
#  id           | integer        | unique
#  name         | string         | maximum of 250 characters
#  slug         | string         | maximum of 250 characters, based on name
#  created_at   | datetime       | <= updated_at
#  updated_at   | datetime       | >= created_at
# ================================================================================

class Tag < ActiveRecord::Base

	# VALIDATIONS
	# ------------------------------------------------------------
	validates :name, presence: true
	
	# MODULES
	# ------------------------------------------------------------
	extend FriendlyId
	include Taggable
	
	# SCOPES
	# ------------------------------------------------------------
	scope :not_among, ->(tags) { where("name NOT IN (?)", tags) }
	scope :are_among, ->(tags) { where("name IN (?)", tags) }

	# NONTABLE VARIABLES
	# ------------------------------------------------------------
	friendly_id :name, :use => :slugged

	# ASSOCIATIONS
	# ------------------------------------------------------------
	# - Joins
	has_many :taggings

	# - Belongs to
	has_many :articles,      -> { Work.articles },       through: :taggings, source: :work
	has_many :short_stories, -> { Work.short_stories }, through: :taggings, source: :work
	has_many :stories,       -> { Work.stories },       through: :taggings, source: :work
	has_many :story_links,   -> { Work.story_links },   through: :taggings, source: :work
	has_many :works, through: :taggings

	# CLASS METHODS
	# ------------------------------------------------------------
	def self.batch_by_name(str)
		self.transaction do
			str.split(";").map do |name|
				name.strip!
				tag = Tag.where(name: name).first_or_create
			end
		end
	end

	# PUBLIC METHODS
	# ------------------------------------------------------------
	# Heading - defines the main means of addressing the model
	def heading
		name
	end

	def editable? user
		user.site_owner?
	end

end
