require 'active_support/concern'

module Recordable
	extend ActiveSupport::Concern


	# INCLUSION
	# ============================================================
	included do
		# CALLBACKS
		# ------------------------------------------------------------
		before_validation :update_tags,     on: [:update, :create]
		after_save        :update_creators, on: [:update, :create]

		# SCOPES
		# ------------------------------------------------------------
		scope :seek_with_creator, ->(creator_name) { joins(:creators).where("characters.name IN (?)", creator_name) }
		scope :seek_with_type,    ->(type_name)    { joins('LEFT OUTER JOIN "record_metadata" ON "record_metadata"."work_id" = "works"."id"').where("((key = 'medium' AND value = ?) OR type = ?)", type_name, type_name.split(' ').collect(&:capitalize).join) }

		# ASSOCIATIONS
		# ------------------------------------------------------------
		# JOINS
		# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		has_many :creatorships, dependent: :destroy
		has_many :appearances,  dependent: :destroy
		has_many :taggings,     dependent: :destroy
		has_many :settings,     dependent: :destroy

		has_many :tagged_connections,  class_name: "WorkConnection", dependent: :destroy, foreign_key: "tagger_id"
		has_many :tagging_connections, class_name: "WorkConnection", dependent: :destroy, foreign_key: "tagged_id"

		has_many :main_appearances,      -> { Appearance.main_character }, class_name: "Appearance"
		has_many :side_appearances,      -> { Appearance.side },           class_name: "Appearance"
		has_many :mentioned_appearances, -> { Appearance.mentioned },      class_name: "Appearance"
		has_many :subject_appearances,   -> { Appearance.subject },        class_name: "Appearance"

		has_many :general_tagging_connections,   -> { WorkConnection.general    }, class_name: "WorkConnection", foreign_key: "tagged_id"
		has_many :set_in_tagging_connections,    -> { WorkConnection.set_in     }, class_name: "WorkConnection", foreign_key: "tagged_id"
		has_many :cast_from_tagging_connections, -> { WorkConnection.cast_from  }, class_name: "WorkConnection", foreign_key: "tagged_id"
		has_many :mentioned_tagging_connections, -> { WorkConnection.mentioned  }, class_name: "WorkConnection", foreign_key: "tagged_id"
		has_many :subject_tagging_connections,   -> { WorkConnection.subject    }, class_name: "WorkConnection", foreign_key: "tagged_id"
		has_many :reference_tagging_connections, -> { WorkConnection.referenced }, class_name: "WorkConnection", foreign_key: "tagged_id"

		has_many :general_tagged_connections,   -> { WorkConnection.general    }, class_name: "WorkConnection", foreign_key: "tagger_id"
		has_many :set_in_tagged_connections,    -> { WorkConnection.set_in     }, class_name: "WorkConnection", foreign_key: "tagger_id"
		has_many :cast_from_tagged_connections, -> { WorkConnection.cast_from  }, class_name: "WorkConnection", foreign_key: "tagger_id"
		has_many :mentioned_tagged_connections, -> { WorkConnection.mentioned  }, class_name: "WorkConnection", foreign_key: "tagger_id"
		has_many :subject_tagged_connections,   -> { WorkConnection.subject    }, class_name: "WorkConnection", foreign_key: "tagger_id"
		has_many :reference_tagged_connections, -> { WorkConnection.referenced }, class_name: "WorkConnection", foreign_key: "tagger_id"

		# BELONGS TO
		# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		has_many   :tagging_works,  through: :tagging_connections
		belongs_to :type_describer, class_name: "WorksTypeDescriber", foreign_key: "type", primary_key: "name"

		# HAS
		# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		has_many :metadata, foreign_key: "work_id", class_name: "RecordMetadatum", dependent: :destroy
		has_many :creators, :through => :creatorships

		has_many :characters, ->{uniq}, :through => :appearances
		has_many :works,      ->{uniq}, :through => :tagged_connections

		has_many :places,     ->{uniq}, :through => :settings, extend: TagWithUploadable
		has_many :tags,       ->{uniq}, :through => :taggings, extend: TagWithUploadable

		has_many :main_characters,      :through => :main_appearances,      extend: TagWithUploadable
		has_many :side_characters,      :through => :side_appearances,      extend: TagWithUploadable
		has_many :mentioned_characters, :through => :mentioned_appearances, extend: TagWithUploadable
		has_many :people_subjects,      :through => :subject_appearances,   extend: TagWithUploadable

		has_many :general_works,   :through => :general_tagged_connections,   extend: TagWithWork
		has_many :set_in_works,    :through => :set_in_tagged_connections,    extend: TagWithWork
		has_many :cast_from_works, :through => :cast_from_tagged_connections, extend: TagWithWork
		has_many :mentioned_works, :through => :mentioned_tagged_connections, extend: TagWithWork

		has_many :work_subjects,   :through => :subject_tagged_connections,   extend: TagWithWork
		has_many :work_references, :through => :reference_tagged_connections, extend: TagWithWork

		has_many :general_in,    through: :general_tagging_connections,   source: :tagging_work
		has_many :setting_of,    through: :set_in_tagging_connections,    source: :tagging_work
		has_many :cast_for,      through: :cast_from_tagging_connections, source: :tagging_work
		has_many :mentioner,     through: :mentioned_tagging_connections, source: :tagging_work

		has_many :subject_of,    through: :subject_tagging_connections,   source: :tagging_work
		has_many :reference_for, through: :reference_tagging_connections, source: :tagging_work

		# REFERENCES
		# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		has_many :identities, ->{uniq}, :through => :characters
		has_many :creator_categories,   :through => :type_describer
	end

	# ATTRIBUTES
	# ============================================================
	attr_accessor :visitor, :appearables, :placeables, :taggables, :uploadership, :relateables

	def appearables
		@appearables  ||= { :main => "", :side => "", :mentioned => "", :subject => "" }
	end

	def placeables
		@placeables   ||= ""
	end

	def relateables
		@relateables  ||= {:general => "", :mentioned => "", :subject => "", :setting => "", :characters => "", :reference => ""}
	end

	def taggables
		@taggables    ||= ""
	end

	def uploadership
		@uploadership ||= { :category => nil, :pen_name => nil }
	end

	def visitor
		@visitor      ||= nil
	end

	# PUBLIC METHODS
	# ============================================================
	# GETTERS
	# ------------------------------------------------------------
	def organized_characters
		@organized_characters ||= Appearance.organize(self.appearances.includes(:character))
	end

	def all_character_names
		self.characters.map(&:name)
	end

	def place_names
		self.places.map(&:name)
	end

	def tag_names
		self.tags.map(&:name)
	end

	def categorized_type
		self.type.gsub(/[a-zA-Z](?=[A-Z])/, '\0 ').titleize
	end

	def tag_heading
		title + " [#{categorized_type}]"
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

	# PRIVATE METHODS
	# ============================================================
	private
	def update_creators
		up_cat_id = uploadership[:category]
		up_nam_id = uploadership[:pen_name]

		unless up_cat_id.nil?
			editor_creatorize(up_cat_id, up_nam_id, visitor)
		end
	end

	# GENERAL TAGS
	# ------------------------------------------------------------
	def update_tags
		updated_place_tags(placeables)
		updated_general_tags(taggables)

		if self.narrative?
			find_main_characters      appearables[:main]
			find_side_characters      appearables[:side]
			find_mentioned_characters appearables[:mentioned]

			find_general_works   relateables[:general]
			find_set_in_works    relateables[:setting]
			find_cast_from_works relateables[:characters]
			find_mentioned_works relateables[:mentioned]
		else
			find_people_subjects appearables[:subject]
			find_work_subjects   relateables[:subject]
			find_work_subjects   relateables[:reference]
		end
	end

	def organize_tags(old_tags, new_tags)
		old_tags.delete(old_tags - new_tags)
		old_tags <<    (new_tags - old_tags)
	end

	# SPECIFIC TAG TYPES
	# ------------------------------------------------------------
	def updated_place_tags(names)
		old_tags     = self.places
		current_tags = Place.merged_tag_names(old_tags, names, visitor)
		organize_tags(old_tags, current_tags)
	end

	def updated_general_tags(names)
		old_tags     = self.tags
		current_tags = Tag.merged_tag_names(old_tags, names, visitor)
		organize_tags(old_tags, current_tags)
	end

	# CHARACTER TAGS
	# ------------------------------------------------------------
	def find_main_characters(names)
		old_tags     = self.main_characters
		current_tags = Character.merged_tag_names(old_tags, names, visitor)
		organize_tags(old_tags, current_tags)
	end

	def find_mentioned_characters(names)
		old_tags     = self.mentioned_characters
		current_tags = Character.merged_tag_names(old_tags, names, visitor)
		organize_tags(old_tags, current_tags)
	end

	def find_side_characters(names)
		old_tags     = self.side_characters
		current_tags = Character.merged_tag_names(old_tags, names, visitor)
		organize_tags(old_tags, current_tags)
	end

	def find_people_subjects(names)
		old_tags     = self.people_subjects
		current_tags = Character.merged_tag_names(old_tags, names, visitor)
		organize_tags(old_tags, current_tags)
	end

	# Work TAGS
	# ------------------------------------------------------------
	def find_general_works(titles)
		old_tags     = self.general_works
		current_tags = Work.merged_tag_names(old_tags, titles, visitor)
		organize_tags(old_tags, current_tags)
	end

	def find_set_in_works(titles)
		old_tags     = self.set_in_works
		current_tags = Work.merged_tag_names(old_tags, titles, visitor)
		organize_tags(old_tags, current_tags)
	end

	def find_cast_from_works(titles)
		old_tags     = self.cast_from_works
		current_tags = Work.merged_tag_names(old_tags, titles, visitor)
		organize_tags(old_tags, current_tags)
	end

	def find_mentioned_works(titles)
		old_tags     = self.mentioned_works
		current_tags = Work.merged_tag_names(old_tags, titles, visitor)
		organize_tags(old_tags, current_tags)
	end

	def find_work_subjects(titles)
		old_tags     = self.work_subjects
		current_tags = Work.merged_tag_names(old_tags, titles, visitor)
		organize_tags(old_tags, current_tags)
	end

	def find_work_references(titles)
		old_tags     = self.work_references
		current_tags = Work.merged_tag_names(old_tags, titles, visitor)
		organize_tags(old_tags, current_tags)
	end

end
