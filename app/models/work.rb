# Work
# ================================================================================
# works are part of the creatable content group
#
# Variables (max length: 15 characters) 
# --------------------------------------------------------------------------------
#  variable name   | type        | about
# --------------------------------------------------------------------------------
#  id              | integer     | unique
#  title           | string      | maximum of 250 characters
#  summary         | text        | can be null
#  user_id         | integer     | links to user
#  created_at      | datetime    | must be earlier or equal to updated_at
#  updated_at      | datetime    | must be later or equal to created_at
#
# Methods (max length: 25 characters) 
# --------------------------------------------------------------------------------
#  method name                 | output type | description
# --------------------------------------------------------------------------------
#  heading                     | string      | defines the main means of
#                              |             | addressing the model
#  content_distribution        | array       | collects the totals number of 
#                              |             | chapters and notes
#  editable?                   | bool        | asks if work can be edited
#  self.sorter                 | string      | decide on the sort order
# ================================================================================

class Work < ActiveRecord::Base

	# VALIDATIONS
	# ------------------------------------------------------------
	validates :title, length: { maximum: 250 }, presence: true

	# SCOPES
	# ------------------------------------------------------------
	# - General
	scope :recently_updated, ->(num) { order(:updated_at => :desc).limit(num) }
	scope :assort,           ->(date, order) { Work.span(date).order_by(order) }

	# - Time Period
	scope :within_day,   -> { where("works.updated_at > ? ", 1.day.ago) }
	scope :within_month, -> { where("works.updated_at > ? ", 1.month.ago) }
	scope :within_year,  -> { where("works.updated_at > ? ", 1.year.ago) }

	# - Order
	scope :chronological, -> { order("works.created_at asc") }
	scope :alphabetical,  -> { order("lower(works.title) asc") }
	scope :updated,       -> { order("works.updated_at desc") }

	# NONTABLE VARIABLES
	# ------------------------------------------------------------
	attr_reader :content_distribution
	def after_initialize
		content_distribution()
	end

	# ASSOCIATIONS
	# ------------------------------------------------------------
	# joins
	has_many :collections
	has_many :appearances
	has_many :respondences, as: :response
	has_many :work_tags

	# models that possess these models
	belongs_to :user
	has_many :anthologies, :through => :collections
	has_many :callers,     :through => :respondences

	# models that belong to this model
	has_many :chapters, :inverse_of => :work
	has_many :notes,    :inverse_of => :work

	# models that are refrenced by these models
	has_many :characters, :through => :appearances
	has_many :tags,       :through => :work_tags

	# indirect associations and subgroups
	has_many :identities, ->{uniq}, :through => :characters
	has_many :main_characters, -> { where(appearances: {role: 'main'}) }, :through => :appearances, :class_name => 'Character', source: :character, :foreign_key => 'character_id'
	has_many :side_characters, -> { where(appearances: {role: 'side'}) }, :through => :appearances, :class_name => 'Character', source: :character, :foreign_key => 'character_id'
	has_many :mentioned_characters, -> { where(appearances: {role: 'mentioned'}) }, :through => :appearances, :class_name => 'Character', source: :character, :foreign_key => 'character_id'

	# DELEGATIONS
	# ------------------------------------------------------------
	delegate :concepts, :activities, :qualities, :to => :work_tags
	
	# NESTED ATTRIBUTION
	# ------------------------------------------------------------
	accepts_nested_attributes_for :appearances, :allow_destroy => true

	# METHODS
	# ------------------------------------------------------------
	# Heading
	# - defines the main means of addressing the model
	def heading
		title
	end

	# ContentDistribution
	# - collects the totals number of chapters and notes
	def content_distribution
		@content_distribution = {
			:chapters => Chapter.where(:work_id => self.id).count,
			:notes => Note.where(:work_id => self.id).count
		}
	end

	# Editable?
	# - asks if work can be edited
	def editable?(user)
		self.user.id == user.id
	end

	# CLASS METHODS
	# ------------------------------------------------------------
	# Sorter
	# - decide on the sort order
	def self.order_by(choice)
		case choice
		when "alphabetical"
			alphabetical
		when "chronological"
			chronological
		else
			updated
		end
	end

	# Span
	# - define the time span
	def self.span(choice)
		case choice
		when "thisyear"
			within_year
		when "thismonth"
			within_month
		when "today"
			within_day
		else
			all
		end
	end

	# Rand
	# - get a random work
	def self.any(count = 1)
		Work.offset(rand(Work.count)).limit(count)
	end

end
