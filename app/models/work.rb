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

	# MODULES
	# ============================================================
	include Discussable
	include Editable
	include Summarizable
	include Titleizeable

	# CALLBACKS
	# ============================================================
	before_validation :set_default,     on: [:update, :create]
	before_validation :update_tags,     on: [:update, :create]
	after_save        :update_creators, on: [:update, :create]

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
	has_many :appearances,  dependent: :destroy
	has_many :respondences, dependent: :destroy, foreign_key: "response_id"
	has_many :taggings,     dependent: :destroy
	has_many :settings,     dependent: :destroy
	has_many :creatorships, dependent: :destroy
	has_one  :skinning,     dependent: :destroy

	# BELONGS TO
	# ------------------------------------------------------------
	has_many :anthologies,   :through => :collections
	has_many :callers,       :through => :respondences
	belongs_to :type_describer, class_name: "WorksTypeDescriber", foreign_key: "type", primary_key: "name"

	# HAS
	# ------------------------------------------------------------
	has_many :creators, :through    => :creatorships, source: :user
	has_one  :rating,   :inverse_of => :work
	has_one  :skin,     :through    => :skinning, :inverse_of => :works
	has_many :sources,  :dependent  => :destroy,  as: :referencer

	has_many :characters, ->{uniq}, :through => :appearances
	has_many :places,     ->{uniq}, :through => :settings
	has_many :tags,       ->{uniq}, :through => :taggings

	has_many :main_characters,      :through => :appearances
	has_many :side_characters,      :through => :appearances
	has_many :mentioned_characters, :through => :appearances
	has_many :people_subjects,      :through => :appearances
	
	# REFERENCES
	# ------------------------------------------------------------
	has_many :identities, ->{uniq}, :through => :characters
	has_many :creator_categories,   :through => :type_describer

	# NESTED ATTRIBUTION
	# ============================================================
	accepts_nested_attributes_for :appearances, :allow_destroy => true
	accepts_nested_attributes_for :settings,    :allow_destroy => true
	accepts_nested_attributes_for :rating,      :allow_destroy => true
	accepts_nested_attributes_for :skinning,    :allow_destroy => true
	accepts_nested_attributes_for :sources,     :allow_destroy => true

	# DELEGATED METHODS
	# ============================================================
	delegate :narrative?,   to: :type_describer
	delegate :is_singleton, to: :type_describer
	delegate :record?,      to: :type_describer

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
		rate_options = options.slice(:rating_min, :rating_max, :rating)

		self.ready(cmplt).span(date).order_by(order).page(page_num).with_rating(rate_options)
	end

	def self.with_filters(options = {}, user)
		self.assort(options).viewable_for(user).with_relationships
	end

	def self.with_relationships
		eager_load(:tags, :places, :rating, :main_characters, :type_describer, :uploader)
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

	# ATTRIBUTES
	# ============================================================
	attr_accessor :visitor, :appearables, :placeables, :taggables, :uploadership

	def appearables
		@appearables ||= { :main => "", :side => "", :mentioned => "", :subject => "" }
	end

	def placeables
		@placeables ||= ""
	end

	def taggables
		@taggables ||= ""
	end

	def uploadership
		@uploadership ||= { :category => nil, :pen_name => nil }
	end

	def visitor
		@visitor ||= nil
	end

	# PUBLIC METHODS
	# ============================================================
	# GETTERS
	# ------------------------------------------------------------
	def heading
		title
	end

	def organized_characters
		@organized_characters ||= Appearance.organize(self.appearances.includes(:character))
	end

	def rated
		self.rating.heading
	end

	def place_names
		self.places.map(&:name)
	end

	def tag_names
		self.tags.map(&:name)
	end

	# ACTIONS
	# ------------------------------------------------------------
	def init_characters
		lst = Appearance.init_hash(self)
		appearances = self.appearances.joins(:character)
		appearances.each do |character|
			lst[character.role] ||= Array.new
			lst[character.role] << character.name
		end
		return lst
	end

	def rate(v, s, l)
		Rating.create(work_id: self.id, violence: v, sexuality: s, language: l)
	end

	def creatorize(catid, nameid)
		Creatorship.create(creator_category_id: catid, creator_id: nameid, work_id: self.id)
	end

	def editor_creatorize(catid, nameid, editor)
		editor_pen = self.creatorships.are_among_for(editor.all_pens.pluck(:id)).first

		if editor_pen.nil?
			creatorize(catid, nameid)
		elsif nameid != editor_pen.id
			editor_pen.update(creator_category_id: catid, creator_id: nameid)
		end
	end

	# QUESTIONS
	# ------------------------------------------------------------
	# Complete? - self explantory
	def complete?
		self.is_complete == 't' || self.is_complete == true
	end

	# PRIVATE METHODS
	# ============================================================
	private

	def update_creators
		up_cat = uploadership[:category]
		up_nam = uploadership[:pen_name]

		unless up_cat.nil?
			editor_creatorize(up_cat, up_nam, visitor)
		end
	end

	def set_default
		self.type ||= "Story"
		self.editor_level    ||= Editable::PERSONAL
		self.publicity_level ||= Editable::PUBLIC
	end

	# GENERAL TAGS
	# ------------------------------------------------------------
	def update_tags
		organize_tags(self.places, Place.batch_by_name(placeables, visitor))
		organize_tags(self.tags, Tag.batch_by_name(taggables))

		if self.narrative?
			find_main_characters appearables[:main]
			find_side_characters appearables[:side]
			find_mentioned_characters appearables[:mentioned]
		else
			find_people_subjects appearables[:subject]
		end
	end

	def organize_tags(old_tags, new_tags)
		old_tags.delete(old_tags - new_tags)
		old_tags <<    (new_tags - old_tags)
	end

	# CHARACTER TAGS
	# ------------------------------------------------------------
	def find_main_characters(names)
		organize_tags(self.main_characters, Character.batch_by_name(names, visitor))
	end

	def find_mentioned_characters(names)
		organize_tags(self.mentioned_characters, Character.batch_by_name(names, visitor))
	end

	def find_side_characters(names)
		organize_tags(self.side_characters, Character.batch_by_name(names, visitor))
	end

	def find_people_subjects(names)
		organize_tags(self.people_subjects, Character.batch_by_name(names, visitor))
	end

end