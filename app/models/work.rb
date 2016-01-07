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
	include Summarizable

	# CALLBACKS
	# ------------------------------------------------------------
	#after_initialize :defaults

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
	scope :articles,      -> { where(:type => "Article") }
	scope :short_stories, -> { where(:type => "ShortStory") }
	scope :stories,       -> { where(:type => "Story") }
	scope :story_links,   -> { where(:type => "StoryLinks") }

	# - Categories
	scope :fiction,    -> { where("type IN (?)", WorksTypeDescriber.fiction.pluck(:name)) }
	scope :nonfiction, -> { where("type IN (?)", WorksTypeDescriber.nonfiction.pluck(:name)) }

	scope :chaptered,  -> { where("type IN (?)", WorksTypeDescriber.chaptered.pluck(:name)) }
	scope :oneshot,    -> { where("type IN (?)", WorksTypeDescriber.oneshot.pluck(:name)) }
	
	scope :complete,   -> { where("is_complete  = 't'") }
	scope :incomplete, -> { where("is_complete  = 'f'") }

	scope :local,      -> { where("type IN (?)", WorksTypeDescriber.local.pluck(:name)) }
	scope :offsite,    -> { where("type IN (?)", WorksTypeDescriber.offsite.pluck(:name)) }

	# ASSOCIATIONS
	# ------------------------------------------------------------
	# - Joins
	has_many :collections,  dependent: :destroy
	has_many :appearances,  dependent: :destroy
	has_many :respondences, dependent: :destroy, as: :response
	has_many :taggings,     dependent: :destroy
	has_many :settings,     dependent: :destroy
	has_many :creatorships, dependent: :destroy
	has_one  :skinning,     dependent: :destroy

	# - Belongs to
	has_many :anthologies,   :through => :collections
	has_many :callers,       :through => :respondences
	belongs_to :contentable, class_name: "WorksTypeDescriber", foreign_key: "type", primary_key: "name"

	# - Has
	has_many :creators, :through    => :creatorships, source: :user
	has_one  :rating,   :inverse_of => :work
	has_many :tags,     :through    => :taggings
	has_many :places,   :through    => :settings
	has_one  :skin,     :through    => :skinning, :inverse_of => :works
	has_many :sources,  :dependent  => :destroy,  as: :referencer

	has_many :characters,      :through => :appearances
	has_many :main_characters, :through => :appearances
	has_many :side_characters, :through => :appearances
	has_many :mentioned_characters, :through => :appearances
	has_many :people_subjects,      :through => :appearances
	
	# - References
	has_many :identities, ->{uniq}, :through => :characters

	# NESTED ATTRIBUTION
	# ------------------------------------------------------------
	accepts_nested_attributes_for :appearances, :allow_destroy => true
	accepts_nested_attributes_for :settings,    :allow_destroy => true
	accepts_nested_attributes_for :rating,      :allow_destroy => true
	accepts_nested_attributes_for :skinning,    :allow_destroy => true
	accepts_nested_attributes_for :sources,     :allow_destroy => true

	# DELEGATED METHODS
	# ------------------------------------------------------------
	delegate :narrative?,   to: :contentable
	delegate :is_singleton, to: :contentable
	delegate :record?,      to: :contentable

	# CLASS METHODS
	# ------------------------------------------------------------
	def self.assort(options = {})
		date     = options[:date]
		order    = options[:sort]
		page_num = options[:page]
		cmplt    = options[:completion]
		rate_options = options.slice(:rating_min, :rating_max, :rating)

		self.ready(cmplt).span(date).order_by(order).page(page_num).with_rating(rate_options)
	end

	def self.with_rating(rate_options)
		unless rate_options.nil? || rate_options.length < 1
			joins(:rating).merge(Rating.choose(rate_options))
		else
			all
		end
	end

	def self.with_filters(options = {}, user)
		self.assort(options).viewable_for(user).with_relationships
	end

	def self.with_relationships
		eager_load(:tags, :places, :rating, :main_characters, :contentable, :uploader)
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

	# Status - define completion
	def self.ready(seeking_completion)
		case seeking_completion
		when "yes"
			complete
		when "no"
			incomplete
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
	# Complete? - self explantory
	def complete?
		self.is_complete == 't' || self.is_complete == true
	end

end
