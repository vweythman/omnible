require 'active_support/concern'

module WithWorkCuration
	extend ActiveSupport::Concern

	# INCLUSION
	# ============================================================
	included do

		# ASSOCIATIONS
		# ------------------------------------------------------------
		has_many :intrawork_identities, through: :works, source: :identities,    extend: OnAppearanceIdentities
		has_many :intrawork_characters, through: :works, source: :characters,    extend: OnAppearances
		has_many :intrawork_groups,     through: :works, source: :social_groups, extend: OnSocialAppearances

		has_many :intrawork_tags,   through: :works, source: :tags,   extend: OnTaggings
		has_many :intrawork_places, through: :works, source: :places, extend: OnSettings
		has_many :intraworks,       through: :works, source: :works,  extend: OnIntrataggings do
			def onsite_ordered_title_count
				where("works_intraworks_join.type NOT IN (#{WorksTypeDescriber.offsite_sql})").ordered_title_count
			end
		end

	end

	def tagging_works
		works
	end

end
