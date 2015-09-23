# Work
# ================================================================================
# creations
#
# Table Variables
# --------------------------------------------------------------------------------
#  variable name   | type        | about
# --------------------------------------------------------------------------------
#  id              | integer     | unique
#  title           | string      | max: 250 characters
#  summary         | text        | can be null
#  uploader_id     | integer     | references user
#  created_at      | datetime    | <= updated_at
#  updated_at      | datetime    | >= created_at
#  publicity_level | integer     | cannot be null
#  is_complete     | boolean     | default: false
#  is_narrative    | boolean     | default: true
#  editor_level    | integer     | cannot be null
#  type            | string      | sti value
#  is_singleton    | boolean     | default: true
# ================================================================================

class Work < ActiveRecord::Base

	# VALIDATIONS
	# ------------------------------------------------------------
	validates :title, length: { maximum: 250 }, presence: true

	# MODULES
	# ------------------------------------------------------------
	include Editable
	include Discussable

	# CALLBACKS
	# ------------------------------------------------------------
	after_initialize :defaults

	# SCOPES
	# ------------------------------------------------------------
	# - General
	scope :recently_updated, ->(num) { order(:updated_at => :desc).limit(num) }

	# - Time Period
	scope :within_day,   -> { where("works.updated_at > ? ", 1.day.ago) }
	scope :within_month, -> { where("works.updated_at > ? ", 1.month.ago) }
	scope :within_year,  -> { where("works.updated_at > ? ", 1.year.ago) }

	# - Order
	scope :chronological, -> { order("works.created_at asc") }
	scope :alphabetical,  -> { order("lower(works.title) asc") }
	scope :updated,       -> { order("works.updated_at desc") }
	scope :by_chapters,   -> { order("(SELECT COUNT(*) FROM chapters WHERE story_id = works.id) desc")}

	# - Types
	scope :stories,          -> { where(:type => "Story") }
	scope :short_stories,    -> { where(:type => "ShortStory") }
	scope :story_records, -> {where(:type => "ExternalStory") }

	# - Categories
	scope :fiction,    -> { where("is_narrative = 't'") }
	scope :nonfiction, -> { where("is_narrative = 'f'") }

	scope :chaptered,  -> { where("is_singleton = 'f'") }
	scope :oneshot,    -> { where("is_singleton = 't'") }
	
	scope :complete,   -> { where("is_complete  = 't'") }
	scope :incomplete, -> { where("is_complete  = 'f'") }

	# ASSOCIATIONS
	# ------------------------------------------------------------
	# - Joins
	has_many :collections
	has_many :appearances
	has_many :respondences, as: :response
	has_many :taggings

	# - Belongs to
	has_many :anthologies,   :through => :collections
	has_many :callers,       :through => :respondences
	belongs_to :contentable, :polymorphic => true

	# - Has
	has_one  :rating

	# - References
	has_many :characters,      :through => :appearances
	has_many :main_characters, :through => :appearances
	has_many :side_characters, :through => :appearances
	has_many :mentioned_characters, :through => :appearances
	
	has_many :identities, ->{uniq}, :through => :characters
	has_many :tags, :through => :taggings

	# NESTED ATTRIBUTION
	# ------------------------------------------------------------
	accepts_nested_attributes_for :appearances, :allow_destroy => true
	accepts_nested_attributes_for :rating,      :allow_destroy => true

	# CLASS METHODS
	# ------------------------------------------------------------
	def self.assort(options = {})
		date     = options[:date]
		order    = options[:sort]
		page_num = options[:page]
		rate_options = options.slice(:rating_min, :rating_max, :rating)

		self.span(date).order_by(order).joins(:rating).merge(Rating.choose(rate_options)).page(page_num)
	end

	def self.with_filters(options = {}, user)
		self.assort(options).viewable_for(user, "works.").eager_load(:tags, :main_characters, :rating, :uploader)
	end

	# OrderBy - decide on the sort order
	def self.order_by(choice)
		case choice
		when "alphabetical"
			alphabetical
		when "chronological"
			chronological
		when "chapter-count"
			by_chapters
		else
			updated
		end
	end

	# Span - define the time span
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

	# Any - get a random work
	def self.any(count = 1)
		Work.offset(rand(Work.count)).limit(count)
	end

	# CALLBACK METHODS
	# ------------------------------------------------------------
	attr_reader :content_distribution
	def after_initialize
		content_distribution()
	end

	# PUBLIC METHODS
	# ------------------------------------------------------------
	# GETTERS
	# ............................................................
	# Heading - defines the main means of addressing the model
	def heading
		title
	end

	# OrganizedCharacters - Self Explanatory
	def organized_characters
		appearances = self.appearances.includes(:character)
		Appearance.organize(appearances)
	end

	# ContentDistribution - collects the totals number of chapters and notes
	def content_distribution
		@content_distribution ||= {
			:notes => self.notes.size
		}
	end

	# Rated - rating level set at highest
	def rated
		self.rating.heading
	end

	# ACTIONS
	# ............................................................
	# InitCharacters - 
	def init_characters
		lst = Appearance.init_hash(self)
		appearances = self.appearances.joins(:character)
		appearances.each do |character|
			lst[character.role] ||= Array.new
			lst[character.role] << character.name
		end
		return lst
	end

	# Rate - defines the work's rating
	def rate(v, s, l)
		Rating.create(work_id: self.id, violence: v, sexuality: s, language: l)
	end

	# QUESTIONS
	# ............................................................
	# Narrative? - fiction vs. non-fiction
	def narrative?
		self.is_narrative == 't' || self.is_narrative == true
	end

	# Complete? - self explantory
	def complete?
		self.is_complete == 't' || self.is_complete == true
	end

	# PRIVATE METHODS
	# ------------------------------------------------------------
	# Defaults - self explanatory
	def defaults
		self.rating ||= Rating.new
	end

end
