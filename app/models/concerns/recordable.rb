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
		has_many :taggings,     dependent: :destroy, as: :tagger
		has_many :settings,     dependent: :destroy

		has_many :intratagged,   class_name: "WorkConnection", dependent: :destroy, foreign_key: "tagger_id"
		has_many :intrataggings, class_name: "WorkConnection", dependent: :destroy, foreign_key: "tagged_id"

		has_many :main_appearances,      -> { Appearance.main_character }, class_name: "Appearance"
		has_many :side_appearances,      -> { Appearance.side },           class_name: "Appearance"
		has_many :mentioned_appearances, -> { Appearance.mentioned },      class_name: "Appearance"
		has_many :subject_appearances,   -> { Appearance.subject },        class_name: "Appearance"

		has_many :general_intrataggings,   -> { WorkConnection.general    }, class_name: "WorkConnection", foreign_key: "tagged_id"
		has_many :set_in_intrataggings,    -> { WorkConnection.set_in     }, class_name: "WorkConnection", foreign_key: "tagged_id"
		has_many :cast_from_intrataggings, -> { WorkConnection.cast_from  }, class_name: "WorkConnection", foreign_key: "tagged_id"
		has_many :subject_intrataggings,   -> { WorkConnection.subject    }, class_name: "WorkConnection", foreign_key: "tagged_id"
		has_many :reference_intrataggings, -> { WorkConnection.referenced }, class_name: "WorkConnection", foreign_key: "tagged_id"

		has_many :general_intratagged,   -> { WorkConnection.general    }, class_name: "WorkConnection", foreign_key: "tagger_id"
		has_many :set_in_intratagged,    -> { WorkConnection.set_in     }, class_name: "WorkConnection", foreign_key: "tagger_id"
		has_many :cast_from_intratagged, -> { WorkConnection.cast_from  }, class_name: "WorkConnection", foreign_key: "tagger_id"
		has_many :subject_intratagged,   -> { WorkConnection.subject    }, class_name: "WorkConnection", foreign_key: "tagger_id"
		has_many :reference_intratagged, -> { WorkConnection.referenced }, class_name: "WorkConnection", foreign_key: "tagger_id"

		# BELONGS TO
		# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		has_many   :tagging_works,  through: :intrataggings
		belongs_to :type_describer, class_name: "WorksTypeDescriber", foreign_key: "type", primary_key: "name"

		# HAS
		# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		has_many :metadata, foreign_key: "work_id", class_name: "RecordMetadatum", dependent: :destroy
		has_many :creators, :through => :creatorships

		has_many :characters, ->{uniq}, :through => :appearances
		has_many :works,      ->{uniq}, :through => :intratagged

		has_many :places,     ->{uniq}, :through => :settings
		has_many :tags,       ->{uniq}, :through => :taggings

		has_many :main_characters,      :through => :main_appearances
		has_many :side_characters,      :through => :side_appearances
		has_many :mentioned_characters, :through => :mentioned_appearances
		has_many :people_subjects,      :through => :subject_appearances

		has_many :general_works,   :through => :general_intratagged
		has_many :set_in_works,    :through => :set_in_intratagged
		has_many :cast_from_works, :through => :cast_from_intratagged
		has_many :work_subjects,   :through => :subject_intratagged
		has_many :work_references, :through => :reference_intratagged

		has_many :general_in,    through: :general_intrataggings,   source: :tagging_work
		has_many :setting_of,    through: :set_in_intrataggings,    source: :tagging_work
		has_many :cast_for,      through: :cast_from_intrataggings, source: :tagging_work
		has_many :subject_of,    through: :subject_intrataggings,   source: :tagging_work
		has_many :reference_for, through: :reference_intrataggings, source: :tagging_work

		# REFERENCES
		# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		has_many :identities, ->{uniq}, :through => :characters
		has_many :creator_categories,   :through => :type_describer
	end

	# ATTRIBUTES
	# ============================================================
	attr_accessor :visitor, :appearables, :placeables, :taggables, :uploadership, :relateables

	def appearables
		@appearables  ||= { :main => nil, :side => nil, :mentioned => nil, :subject => nil }
	end

	def placeables
		@placeables   ||= nil
	end

	def relateables
		@relateables  ||= {:general => nil, :subject => nil, :setting => nil, :characters => nil, :reference => nil}
	end

	def taggables
		@taggables    ||= nil
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
		updated_tag_tags(taggables)

		if self.narrative?
			updated_character_tags self.main_characters, appearables[:main]
			updated_character_tags self.side_characters, appearables[:side]
			updated_character_tags self.mentioned_characters, appearables[:mentioned]

			updated_work_tags self.general_works, relateables[:general]
			updated_work_tags self.set_in_works, relateables[:setting]
			updated_work_tags self.cast_from_works, relateables[:characters]
			updated_work_tags self.work_references, relateables[:reference]
		else
			updated_character_tags self.people_subjects, appearables[:subject]
			updated_work_tags self.work_subjects, relateables[:subject]
			updated_work_tags self.work_references, relateables[:reference]
		end
	end

	def organize_tags(old_tags, new_tags)
		old_tags.delete(old_tags - new_tags)
		old_tags <<    (new_tags - old_tags)
	end

	# SPECIFIC TAG TYPES
	# ------------------------------------------------------------
	def updated_place_tags(names)
		unless names.nil?
			old_tags     = self.places
			current_tags = Place.merged_tag_names(old_tags, names, visitor)
			organize_tags(old_tags, current_tags)
		end
	end

	def updated_tag_tags(names)
		unless names.nil?
			old_tags     = self.tags
			current_tags = Tag.merged_tag_names(old_tags, names, visitor)
			organize_tags(old_tags, current_tags)
		end
	end

	def updated_character_tags(old_tags, names)
		organize_tags(old_tags, Character.merged_tag_names(old_tags, names, visitor)) unless names.nil?
	end

	def updated_work_tags(old_tags, titles)
		organize_tags(old_tags, Work.merged_tag_names(old_tags, titles, visitor)) unless titles.nil?
	end

end
