# Setting
# ================================================================================
# join table, tags works with places
#
# Table Variables
# --------------------------------------------------------------------------------
#  variable     | type           | about
# --------------------------------------------------------------------------------
#  id           | integer        | unique
#  work_id      | integer        | references work
#  place_id     | integer        | references place
#  created_at   | datetime       | must be earlier or equal to updated_at
#  updated_at   | datetime       | must be later or equal to created_at
# ================================================================================

class Setting < ActiveRecord::Base

	# MODULES
	# ============================================================
	include CountableTagging

	# VALIDATIONS
	# ------------------------------------------------------------
	validates_uniqueness_of :place_id, :scope => :work_id

	# SCOPES
	# ------------------------------------------------------------
	scope :are_among_for, ->(work, ids) { where("work_id = ? AND place_id IN (?)",     work.id, ids) }
	scope :not_among_for, ->(work, ids) { where("work_id = ? AND place_id NOT IN (?)", work.id, ids) }

	scope :tagger_by_places, ->(ws) { tagger_by_tag_names(ws, :work_id, :place) }

	# ASSOCIATIONS
	# ------------------------------------------------------------
	belongs_to :work
	belongs_to :place

end
