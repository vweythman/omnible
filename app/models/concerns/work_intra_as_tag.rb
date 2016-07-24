require 'active_support/concern'

module WorkIntraAsTag
	extend ActiveSupport::Concern

	# INCLUSION
	# ============================================================
	included do

		# ASSOCIATIONS
		# ------------------------------------------------------------
		# JOINS
		# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		# Unsorted Taggers
		has_many :intrataggings, class_name: "WorkConnection", dependent: :destroy, foreign_key: "tagged_id"

		# Sorted Taggers
		has_many :general_intrataggings,   -> { WorkConnection.general    }, class_name: "WorkConnection", foreign_key: "tagged_id"
		has_many :set_in_intrataggings,    -> { WorkConnection.set_in     }, class_name: "WorkConnection", foreign_key: "tagged_id"
		has_many :cast_from_intrataggings, -> { WorkConnection.cast_from  }, class_name: "WorkConnection", foreign_key: "tagged_id"
		has_many :subject_intrataggings,   -> { WorkConnection.subject    }, class_name: "WorkConnection", foreign_key: "tagged_id"
		has_many :reference_intrataggings, -> { WorkConnection.referenced }, class_name: "WorkConnection", foreign_key: "tagged_id"

		# Has Many
		# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		# Unsorted Taggers
		has_many :tagging_works, through: :intrataggings
		has_many :onsite_taggers, ->{ Work.onsite }, through: :intrataggings, source: :tagging_works

		# Sorted Taggers
		has_many :general_in,    through: :general_intrataggings,   source: :tagging_work
		has_many :setting_of,    through: :set_in_intrataggings,    source: :tagging_work
		has_many :cast_for,      through: :cast_from_intrataggings, source: :tagging_work
		has_many :subject_of,    through: :subject_intrataggings,   source: :tagging_work
		has_many :reference_for, through: :reference_intrataggings, source: :tagging_work

		# REFERENCES
		# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		has_many :intrawork_identities, through: :tagging_works, source: :identities,    extend: OnAppearanceIdentities
		has_many :intrawork_characters, through: :tagging_works, source: :characters,    extend: OnAppearances
		has_many :intrawork_groups,     through: :tagging_works, source: :social_groups, extend: OnSocialAppearances

		has_many :intrawork_tags,   through: :tagging_works, source: :tags,   extend: OnTaggings
		has_many :intrawork_places, through: :tagging_works, source: :places, extend: OnSettings
		has_many :intraworks,       through: :tagging_works, source: :works,  extend: OnIntrataggings do

			def onsite_ordered_title_count
				where("tagging_works_intraworks_join.type NOT IN (#{WorksTypeDescriber.offsite_sql})").ordered_title_count
			end

		end

	end

	def tagging_works_by_type(tagging_type="all")
		case tagging_type
		when "general"
			general_in
		when "setting"
			setting_of
		when "cast"
			cast_for
		when "subject"
			subject_of
		when "reference"
			reference_for
		else
			tagging_works
		end
	end

end
