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
	extend Organizable

	include Discussable
	include Editable
	include Summarizable
	include Titleizeable
	include AsTitleableTag

	include Recordable
	include WorkAppearanceTagging
	include WorkGeneralTagging
	include WorkIntraAsTag
	include WorkIntraAsTagger
	include WorkSocialTagging

	# SCOPES
	# ============================================================
	# COUNTS
	# ------------------------------------------------------------
	scope :count_by_title,          -> { group("works.title").ordered_count }
	scope :count_by_type,           -> { group("type").ordered_count }
	scope :count_by_content_type,   -> { joins(:type_describer).group("content_type").ordered_count }

	scope :count_by_creation_month, -> { group("strftime('%Y-%m', works.created_at)").ordered_count }
	scope :count_by_update_month,   -> { group("strftime('%Y-%m', works.updated_at)").ordered_count }

	scope :type_count_by_creation,  -> { group("strftime('%Y-%m', works.created_at)", "works.type").ordered_count }
	scope :type_count_by_updated,   -> { group("strftime('%Y-%m', works.updated_at)", "works.type").ordered_count }

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
	scope :artwork,           -> { where(:type => "Art")            }
	scope :articles,          -> { where(:type => "Article")        }
	scope :branching_stories, -> { where(:type => "BranchingStory") }
	scope :comics,            -> { where(:type => "Comic")          }
	scope :journals,          -> { where(:type => "Journal")        }
	scope :music_videos,      -> { where(:type => "MusicVideo")     }
	scope :records,           -> { where(:type => "Record")         }
	scope :short_stories,     -> { where(:type => "ShortStory")     }
	scope :stories,           -> { where(:type => "Story")          }
	scope :work_links,        -> { where(:type => "WorkLink")       }
	scope :by_type,           ->(t) { where(:type => t)             }

	# ASSOCIATIONS
	# ============================================================
	# JOINS
	# ------------------------------------------------------------
	has_many :collections,   dependent: :destroy
	has_many :respondences,  dependent: :destroy, foreign_key: "response_id"
	has_one  :skinning,      dependent: :destroy
	has_many :trackings,     dependent: :destroy, as: :tracked
	has_many :work_opinions, dependent: :destroy

	# BELONGS TO
	# ------------------------------------------------------------
	has_many :anthologies, through: :collections
	has_many :callers,     through: :respondences

	# HAS
	# ------------------------------------------------------------
	has_one  :rating, inverse_of: :work
	has_one  :skin,   through:    :skinning, inverse_of: :works 
	
	# NESTED ATTRIBUTION
	# ============================================================
	accepts_nested_attributes_for :rating,   :allow_destroy => true
	accepts_nested_attributes_for :skinning, :allow_destroy => true

	# CLASS METHODS
	# ============================================================
	# VALUES

	def self.public_status_labels
		['incomplete', 'upcoming', 'complete', 'hiatus', 'abandoned']
	end

	def self.hidden_status_labels
		['unknown']
	end

	def self.all_status_labels
		public_status_labels + hidden_status_labels
	end

	# SELECTION
	# ------------------------------------------------------------
	# Any :: random selection
	def self.any(count = 1)
		Work.offset(rand(Work.count)).limit(count)
	end

	# Assort :: general filters
	def self.with_filters(options = {}, user)
		self.assort(options).viewable_for(user).with_relationships
	end

	def self.assort(options = {})
		date     = options[:date]
		order    = options[:sort]
		pnum     = options[:page]

		cmplt    = options[:completion]
		ctype    = options[:content_type]

		withs    = options[:with].nil?    ? {} : options[:with] 
		withouts = options[:without].nil? ? {} : options[:without]

		rwith    = options.slice(:vrating, :srating,    :prating)
		rwithin  = options.slice(:rating,  :rating_min, :rating_max)

		self.ready(cmplt).span(date).order_by(order).page(pnum).contextualize_by(ctype).with_rating(rwith).within_rating(rwithin).filter_by_taggings(withs, withouts)
	end

	def self.viewable_recent_for(user, count = 10)
		recently_updated(count).viewable_for(user).with_relationships
	end

	def self.with_relationships
		eager_load(:tags, :places, :rating, :type_describer, :uploader, :qualitatives, :quantitatives).includes(:appearances => :character)
	end

	def self.filter_by_taggings(withs = {}, withouts = {})
		wi_w = withs[:works]
		wo_w = withouts[:works]

		wi_c = withs[:characters]
		wo_c = withouts[:characters]

		wi_t = withs[:tags]
		wo_t = withouts[:tags]

		wi_p = withs[:tags]
		wo_p = withouts[:tags]

		wi_s = withs[:squads]
		wo_s = withouts[:squads]

		wi_i = withs[:identities]
		wo_i = withouts[:identities]

		filter_by_intraworks(wi_w, wo_w).filter_by_characters(wi_c, wo_c).filter_by_tags(wi_t, wo_t).filter_by_places(wi_p, wo_p).filter_by_squads(wi_s, wo_s).filter_by_identities(wi_i, wo_i)
	end

	# PUBLIC METHODS
	# ============================================================
	# GETTERS
	# ------------------------------------------------------------
	def heading
		title
	end

	# Type - defines the type name if it exists
	def nature
		self.type
	end

	def categorized_type
		self.type.gsub(/[a-zA-Z](?=[A-Z])/, '\0 ').titleize
	end

	def linkable
		self
	end

	def nature
		self.class.to_s
	end
	
	def rated
		self.rating.heading
	end

	def tag_heading
		title + " [#{categorized_type}]"
	end

	def language
		@language ||= 1
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
		self.status == 'complete'
	end

	# DELEGATED METHODS
	# ============================================================
	delegate :narrative?,        to: :type_describer
	delegate :oneshot?,          to: :type_describer
	delegate :record?,           to: :type_describer
	delegate :onsite_multishot?, to: :type_describer
	delegate :watchable?,        to: :type_describer

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
