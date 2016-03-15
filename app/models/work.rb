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
	# ============================================================
	validates :title, length: { maximum: 250 }, presence: true

	# CALLBACKS
	# ============================================================
	before_validation :set_default, on: [:update, :create]

	# MODULES
	# ============================================================
	include Discussable
	include Editable
	include Summarizable
	include Titleizeable
	include AsTitleableTag
	include Recordable

	# SCOPES
	# ============================================================
	# SORTER
	# ------------------------------------------------------------
	scope :chronological, -> { order("works.created_at asc")   }
	scope :alphabetical,  -> { order("lower(works.title) asc") }
	scope :updated,       -> { order("works.updated_at desc")  }
	scope :by_chapters,   -> { order("(SELECT COUNT(*) FROM chapters WHERE story_id = works.id) desc") }

	# CHRONOLOGICAL
	# ------------------------------------------------------------
	scope :recently_updated, ->(num) { updated.limit(num)                          }
	scope :within_day,       ->      { where("works.updated_at > ? ", 1.day.ago)   }
	scope :within_month,     ->      { where("works.updated_at > ? ", 1.month.ago) }
	scope :within_year,      ->      { where("works.updated_at > ? ", 1.year.ago)  }

	# SUBTYPES
	# ------------------------------------------------------------
	scope :articles,      -> { where(:type => "Article")    }
	scope :short_stories, -> { where(:type => "ShortStory") }
	scope :stories,       -> { where(:type => "Story")      }
	scope :story_links,   -> { where(:type => "StoryLinks") }

	# CATEGORIES
	# ------------------------------------------------------------
	scope :fiction,    -> { where("type IN (?)", WorksTypeDescriber.fiction.pluck(:name))    }
	scope :nonfiction, -> { where("type IN (?)", WorksTypeDescriber.nonfiction.pluck(:name)) }

	scope :chaptered,  -> { where("type IN (?)", WorksTypeDescriber.chaptered.pluck(:name)) }
	scope :oneshot,    -> { where("type IN (?)", WorksTypeDescriber.oneshot.pluck(:name))   }
	
	scope :complete,   -> { where("is_complete  = 't'") }
	scope :incomplete, -> { where("is_complete  = 'f'") }

	scope :local,      -> { where("type IN (?)", WorksTypeDescriber.local.pluck(:name))   }
	scope :offsite,    -> { where("type IN (?)", WorksTypeDescriber.offsite.pluck(:name)) }

	# ASSOCIATIONS
	# ============================================================
	# JOINS
	# ------------------------------------------------------------
	has_many :collections,  dependent: :destroy
	has_many :respondences, dependent: :destroy, foreign_key: "response_id"
	has_one  :skinning,     dependent: :destroy

	# BELONGS TO
	# ------------------------------------------------------------
	has_many :anthologies, through: :collections
	has_many :callers,     through: :respondences

	# HAS
	# ------------------------------------------------------------
	has_one  :rating,  :inverse_of => :work
	has_one  :skin,    :through    => :skinning, :inverse_of => :works
	has_many :sources, :dependent  => :destroy,  as: :referencer
	
	# NESTED ATTRIBUTION
	# ============================================================
	accepts_nested_attributes_for :rating,      :allow_destroy => true
	accepts_nested_attributes_for :skinning,    :allow_destroy => true
	accepts_nested_attributes_for :sources,     :allow_destroy => true

	# CLASS METHODS
	# ============================================================
	# SELECTION
	# ------------------------------------------------------------
	# Any :: random selection
	def self.any(count = 1)
		Work.offset(rand(Work.count)).limit(count)
	end

	# Assort :: general filters
	def self.assort(options = {})
		date     = options[:date]
		order    = options[:sort]
		page_num = options[:page]
		cmplt    = options[:completion]
		rate_at_options     = options.slice(:vrating, :srating,    :prating)
		rate_within_options = options.slice(:rating,  :rating_min, :rating_max)

		self.ready(cmplt).span(date).order_by(order).page(page_num).with_rating(rate_at_options).within_rating(rate_within_options)
	end

	def self.with_filters(options = {}, user)
		self.assort(options).viewable_for(user).with_relationships
	end

	def self.with_relationships
		eager_load(:characters, :tags, :places, :rating, :type_describer, :uploader)
	end

	# FILTER ELEMENTS
	# ------------------------------------------------------------
	# OrderBy :: filter by sort
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

	# Ready :: filter by completion
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

	# Span :: filter by time
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

	# WithRating :: filter by rating
	def self.with_rating(rate_options)
		unless rate_options.nil? || rate_options.length < 1
			joins(:rating).merge(Rating.choose(rate_options))
		else
			all
		end
	end

	def self.within_rating(rate_options)
		unless rate_options.nil? || rate_options.length < 1
			joins(:rating).merge(Rating.within_range(rate_options))
		else
			all
		end
	end

	# PUBLIC METHODS
	# ============================================================
	# GETTERS
	# ------------------------------------------------------------
	def heading
		title
	end

	def nature
		self.class.to_s
	end

	def rated
		self.rating.heading
	end

	# ACTIONS
	# ------------------------------------------------------------
	def rate(v, s, l)
		Rating.create(work_id: self.id, violence: v, sexuality: s, language: l)
	end

	# QUESTIONS
	# ------------------------------------------------------------
	# Complete? - self explantory
	def complete?
		self.is_complete == 't' || self.is_complete == true
	end

	# DELEGATED METHODS
	# ============================================================
	delegate :narrative?,   to: :type_describer
	delegate :is_singleton, to: :type_describer
	delegate :record?,      to: :type_describer

	# PRIVATE METHODS
	# ============================================================
	# ============================================================
	private
	def set_default
		self.type            ||= "Record"
		self.editor_level    ||= Editable::PERSONAL
		self.publicity_level ||= Editable::PUBLIC
	end

end