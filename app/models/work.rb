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
#  all_tags                    | array       | aggreagates the general and 
#                              |             | subject tags
#  content_distribution        | array       | collects the totals number of 
#                              |             | chapters and notes
#  set_discussion              | object      | setup a discussion of the work
#  editable?                   | bool        | asks if work can be edited
#  self.sorter                 | string      | decide on the sort order
# ================================================================================

class Work < ActiveRecord::Base

	# VALIDATIONS
	# ------------------------------------------------------------
	validates :title, length: { maximum: 250 }, presence: true

	# MODULES
	# ------------------------------------------------------------
	include Discussable

	# CALLBACKS
	# ------------------------------------------------------------
	after_create :set_discussion

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
	has_many :taggings

	# models that possess these models
	belongs_to :user
	has_many :anthologies, :through => :collections
	has_many :callers,     :through => :respondences

	# models that belong to this model
	has_many :chapters, :inverse_of => :work
	has_many :notes,    :inverse_of => :work
	has_one  :topic,    :inverse_of => :discussed, as: :discussed
	has_many :comments, :through => :discussion

	# models that are refrenced by these models
	has_many :characters, :through => :appearances
	has_many :tags,       :through => :taggings
	has_many :identities, ->{uniq}, :through => :characters

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

	# OrganizedCharacters
	def organized_characters
		appearances = self.appearances.order('role asc').includes(:character)
		Appearance.organize(appearances)
	end

	# ContentDistribution
	# - collects the totals number of chapters and notes
	def content_distribution
		@content_distribution = {
			:chapters => Chapter.where(:work_id => self.id).count,
			:notes => Note.where(:work_id => self.id).count
		}
	end

	# NewChapter
	# - creates a new chapter
	def new_chapter
		chapter = Chapter.new
		chapter.work = self
		chapter.position = self.newest_chapter_position

		return chapter
	end

	# NewestChapterPosition
	# - get position for newest chapter
	def newest_chapter_position
		self.chapters.size + 1
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
