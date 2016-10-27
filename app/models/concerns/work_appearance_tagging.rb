require 'active_support/concern'

module WorkAppearanceTagging
	extend ActiveSupport::Concern

	# INCLUSION
	# ============================================================
	included do

		# CALLBACKS
		# ------------------------------------------------------------
		before_validation :build_character_tags, on: [:update, :create]

		# ASSOCIATIONS
		# ------------------------------------------------------------
		# JOINS
		# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		# Unsorted Tags
		has_many :appearances, dependent: :destroy

		# Sorted Tags
		has_many :main_appearances,      -> { Appearance.main_character }, class_name: "Appearance"
		has_many :side_appearances,      -> { Appearance.side },           class_name: "Appearance"
		has_many :mentioned_appearances, -> { Appearance.mentioned },      class_name: "Appearance"
		has_many :subject_appearances,   -> { Appearance.subject },        class_name: "Appearance"

		# HAS
		# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		# Unsorted Tags
		has_many :characters, ->{uniq}, through: :appearances

		# Sorted Tags
		has_many :main_characters,      through: :main_appearances
		has_many :side_characters,      through: :side_appearances
		has_many :mentioned_characters, through: :mentioned_appearances
		has_many :people_subjects,      through: :subject_appearances

		# REFERENCES
		# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		has_many :identities, ->{uniq}, through: :appearances

	end

	# ATTRIBUTES
	# ============================================================
	attr_accessor :visitor, :appearables
	def appearables
		@appearables ||= { :main => nil, :side => nil, :mentioned => nil, :subject => nil }
	end
	def visitor
		@visitor     ||= nil
	end

	# CLASS METHODS
	# ============================================================
	class_methods do

		# Characters
		# ------------------------------------------------------------
		def filter_by_characters(withs, withouts)
			with_characters(withs).without_characters(withouts)
		end

		def with_characters(taggings)
			if searchable_hash taggings
				with_ordered_characters(taggings)
			elsif searchable_string taggings
				with_unordered_characters(taggings.split(";"))
			else
				all
			end
		end

		def without_characters(taggings)
			if searchable_hash taggings
				without_ordered_characters(taggings)
			elsif searchable_string taggings
				without_unordered_characters(taggings.split(";"))	
			else
				all
			end
		end

		# Identities
		# ------------------------------------------------------------
		def filter_by_identities(withs, withouts)
			with_identities(withs).without_identities(withouts)
		end

		def with_identities(taggings)
			if searchable_hash taggings
				with_ordered_identities(taggings)
			elsif searchable_string taggings
				with_unordered_identities(taggings.split(";"))
			else
				all
			end
		end

		def without_identities(taggings)
			if searchable_hash taggings
				without_ordered_identities(taggings)
			elsif searchable_string taggings
				without_unordered_identities(taggings.split(";"))	
			else
				all
			end
		end

		# PRIVATE CLASS METHODS
		# ============================================================
		private

		# INPUT CLEANING
		# ------------------------------------------------------------
		def searchable_hash(taggings)
			((taggings.is_a? Hash) && !(taggings.values.reject { |v| v.empty? }.empty?))
		end

		def searchable_string(taggings)
			((taggings.is_a? String) && !(taggings.empty?))
		end

		# ORDERED
		# ------------------------------------------------------------
		# Characters
		# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		def with_ordered_characters(taggings)
			where("works.id IN (#{Appearance.tagger_intersection_sql(taggings)})")
		end

		def without_ordered_characters(taggings)
			where("works.id NOT IN (#{Appearance.tagger_intersection_sql(taggings)})")
		end

		# Identities
		# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		def with_ordered_identities(taggings)
			where("works.id IN (#{Appearance.intersect_on_identities(taggings)})")
		end

		def without_ordered_identities(taggings)
			where("works.id NOT IN (#{Appearance.intersect_on_identities(taggings)})")
		end

		# UNSORTED
		# ------------------------------------------------------------
		# Characters
		# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		def with_unordered_characters(titles)
			where("works.id IN (#{Appearance.tagger_by_characters(titles).to_sql})")
		end

		def without_unordered_characters(titles)
			where("works.id NOT IN (#{Appearance.tagger_by_characters(titles).to_sql})")
		end

		# Identities
		# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		def with_unordered_identities(titles)
			where("works.id IN (#{Appearance.tagger_by_identities(titles).to_sql})")
		end

		def without_unordered_identities(titles)
			where("works.id NOT IN (#{Appearance.tagger_by_identities(titles).to_sql})")
		end

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

	# PRIVATE METHODS
	# ============================================================
	private

	def build_character_tags
		if self.narrative?
			updated_character_tags self.main_characters,      appearables[:main]
			updated_character_tags self.side_characters,      appearables[:side]
			updated_character_tags self.mentioned_characters, appearables[:mentioned]
		else
			updated_character_tags self.people_subjects, appearables[:subject]
		end
	end

	def organize_character_tags(old_tags, new_tags)
		old_tags.delete(old_tags - new_tags)
		old_tags <<    (new_tags - old_tags)
	end

	def updated_character_tags(old_tags, names)
		organize_character_tags(old_tags, Character.merged_tag_names(old_tags, names, visitor)) unless names.nil?
	end

end
