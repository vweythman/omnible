# OnAppearances
# ================================================================================
# Extension Method
#
# Methods
# ----------------------------------------
# -- ordered_name_count
# ---- :: returns grouped counts
# ================================================================================
require 'active_support/concern'

module CountableTagging
	extend ActiveSupport::Concern

	# INCLUSION
	# ============================================================
	included do

		# ASSOCIATIONS
		# ------------------------------------------------------------
		scope :group_by_choice,   ->(choice) { group(choice).select(choice)     }
		scope :having_count,      ->(len)    { having("COUNT(*) = #{len.to_i}") }
		scope :with_names_count,  ->(nms)    { where("name IN (?)", nms).having_count(nms.length) }
		scope :with_titles_count, ->(nms)    { where("title IN (?)", nms).having_count(nms.length) }

		scope :tagger_by_tag_names,  ->(nms, tagger_col, tag_type) { joins(tag_type).with_names_count(nms).group_by_choice(tagger_col)  }
		scope :tagger_by_tag_titles, ->(nms, tagger_col, tag_type) { joins(tag_type).with_titles_count(nms).group_by_choice(tagger_col) }
	end

end
