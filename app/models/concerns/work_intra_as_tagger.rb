require 'active_support/concern'

module WorkIntraAsTagger
	extend ActiveSupport::Concern

	# INCLUSION
	# ============================================================
	included do

		# CALLBACKS
		# ------------------------------------------------------------
		before_validation :build_intra_tags, on: [:update, :create]

		# ASSOCIATIONS
		# ------------------------------------------------------------
		# JOINS
		# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		# Unsorted Tags
		has_many :intratagged, class_name: "WorkConnection", dependent: :destroy, foreign_key: "tagger_id"

		# Sorted Tags
		has_many :general_intratagged,   -> { WorkConnection.general    }, class_name: "WorkConnection", foreign_key: "tagger_id"
		has_many :set_in_intratagged,    -> { WorkConnection.set_in     }, class_name: "WorkConnection", foreign_key: "tagger_id"
		has_many :cast_from_intratagged, -> { WorkConnection.cast_from  }, class_name: "WorkConnection", foreign_key: "tagger_id"
		has_many :subject_intratagged,   -> { WorkConnection.subject    }, class_name: "WorkConnection", foreign_key: "tagger_id"
		has_many :reference_intratagged, -> { WorkConnection.referenced }, class_name: "WorkConnection", foreign_key: "tagger_id"

		# HAS
		# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		# Unsorted Tags
		has_many :works, ->{uniq}, through: :intratagged

		# Sorted Tags
		has_many :general_works,   through: :general_intratagged
		has_many :set_in_works,    through: :set_in_intratagged
		has_many :cast_from_works, through: :cast_from_intratagged
		has_many :work_subjects,   through: :subject_intratagged
		has_many :work_references, through: :reference_intratagged

	end

	# ATTRIBUTES
	# ============================================================
	attr_accessor :visitor, :relateables
	def relateables
		@relateables ||= {:general => nil, :subject => nil, :setting => nil, :cast => nil, :reference => nil}
	end
	def visitor
		@visitor     ||= nil
	end

	# CLASS METHODS
	# ============================================================
	class_methods do

		def filter_by_intraworks(withs, withouts)
			with_intraworks(withs).without_intraworks(withouts)
		end

		def with_intraworks(taggings)
			if (taggings.is_a? Hash)
				with_ordered_intraworks(taggings)
			elsif (taggings.is_a? String)
				with_unordered_intraworks(taggings.split(";"))
			else
				all
			end
		end

		def without_intraworks(taggings)
			if (taggings.is_a? Hash)
				without_ordered_intraworks(taggings)
			elsif (taggings.is_a? String)
				without_unordered_intraworks(taggings.split(";"))	
			else
				all
			end		
		end

		private
		# ORDERED
		def with_ordered_intraworks(taggings)
			where("works.id IN (#{WorkConnection.tagger_intersection_sql(taggings)})")
		end

		def without_ordered_intraworks(taggings)
			where("works.id NOT IN (#{WorkConnection.tagger_intersection_sql(taggings)})")
		end

		# UNSORTED
		def with_unordered_intraworks(titles)
			where("works.id IN (#{WorkConnection.tagger_with_works(titles).to_sql})")
		end

		def without_unordered_intraworks(titles)
			where("works.id NOT IN (#{WorkConnection.tagger_with_works(titles).to_sql})")
		end

	end

	# PRIVATE METHODS
	# ============================================================
	private

	def build_intra_tags
		if self.narrative?
			updated_work_tags self.general_works,   relateables[:general]
			updated_work_tags self.set_in_works,    relateables[:setting]
			updated_work_tags self.cast_from_works, relateables[:cast]
			updated_work_tags self.work_references, relateables[:reference]
		else
			updated_work_tags self.work_subjects,   relateables[:subject]
			updated_work_tags self.work_references, relateables[:reference]
		end
	end

	def organize_work_tags(old_tags, new_tags)
		discard_tags = old_tags - new_tags
		added_tags   = new_tags - old_tags

		old_tags.destroy(discard_tags)
		old_tags <<    (added_tags)
	end

	def updated_work_tags(old_tags, titles)
		organize_work_tags(old_tags, Work.merged_tag_names(old_tags, titles, visitor)) unless titles.nil?
	end

end
