require 'active_support/concern'

module WorkGeneralTagging
	extend ActiveSupport::Concern

	# INCLUSION
	# ============================================================
	included do

		# CALLBACKS
		# ------------------------------------------------------------
		before_validation :build_general_tags, on: [:update, :create]

		# ASSOCIATIONS
		# ------------------------------------------------------------
		# JOINS
		# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		# Unsorted Tags
		has_many :settings, dependent: :destroy
		has_many :taggings, dependent: :destroy, as: :tagger

		# Sorted Tags
		has_many :general_taggings, -> { Tagging.general }, dependent: :destroy, class_name: "Tagging", as: :tagger
		has_many :chatter_taggings, -> { Tagging.chatter }, dependent: :destroy, class_name: "Tagging", as: :tagger
		has_many :warning_taggings, -> { Tagging.warning }, dependent: :destroy, class_name: "Tagging", as: :tagger
		has_many :genre_taggings,   -> { Tagging.genre   }, dependent: :destroy, class_name: "Tagging", as: :tagger

		# Has Many
		# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		# Unsorted Tags
		has_many :places, ->{uniq}, through: :settings
		has_many :tags,   ->{uniq}, through: :taggings

		# Sorted Tags
		has_many :general_tags, through: :general_taggings
		has_many :chatter_tags, through: :chatter_taggings
		has_many :warning_tags, through: :warning_taggings
		has_many :genre_tags,   through: :genre_taggings

	end

	# ATTRIBUTES
	# ============================================================
	attr_accessor :visitor, :placeables, :taggables
	def placeables
		@placeables ||= nil
	end
	def taggables
		@taggables  ||= {:commentary => nil, :general => nil, :warning => nil, :genre => nil}
	end
	def visitor
		@visitor    ||= nil
	end

	# CLASS METHODS
	# ============================================================
	class_methods do

		def filter_by_tags(withs, withouts)
			with_tags(withs).without_tags(withouts)
		end

		def filter_by_places(withs, withouts)
			with_places(withs).without_places(withouts)
		end

		def with_tags(taggings)
			if (taggings.is_a? Hash)
				where("works.id IN (#{Tagging.tagger_intersection_sql(taggings, "Work")})")
			elsif (taggings.is_a? String)
				where("works.id IN (#{Tagging.tagger_by_tag(taggings.split(";"), "Work").to_sql})")
			else
				all
			end
		end

		def without_tags(taggings)
			if (taggings.is_a? Hash)
				where("works.id NOT IN (#{Tagging.tagger_intersection_sql(taggings, "Work")})")
			elsif (taggings.is_a? String)
				where("works.id NOT IN (#{Tagging.tagger_by_tag(taggings.split(";"), "Work").to_sql})")
			else
				all
			end
		end

		def with_places(taggings)
			if (taggings.is_a? String)
				where("works.id IN (#{Setting.tagger_by_places(taggings.split(";")).to_sql})")
			else
				all
			end
		end

		def without_places(taggings)
			if (taggings.is_a? String)
				where("works.id NOT IN (#{Setting.tagger_by_places(taggings.split(";")).to_sql})")
			else
				all
			end
		end

	end

	# PUBLIC METHODS
	# ============================================================
	def place_names
		self.places.map(&:name)
	end

	def tag_names
		self.tags.map(&:name)
	end

	# PRIVATE METHODS
	# ============================================================
	private

	def build_general_tags
		updated_place_tags(self.places, placeables)

		updated_true_tags self.chatter_tags, taggables[:commentary]
		updated_true_tags self.general_tags, taggables[:general]
		updated_true_tags self.warning_tags, taggables[:warning]
		updated_true_tags self.genre_tags,   taggables[:genre]
	end

	def organize_tags(old_tags, new_tags)
		old_tags.delete(old_tags - new_tags)
		old_tags <<    (new_tags - old_tags)
	end

	def updated_place_tags(old_tags, names)
		organize_tags(old_tags, Place.merged_tag_names(old_tags, names, visitor)) unless names.nil?
	end

	def updated_true_tags(old_tags, names)
		organize_tags(old_tags, Tag.merged_tag_names(old_tags, names, visitor)) unless names.nil?
	end

end
