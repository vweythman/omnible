# Tagging
# ================================================================================
# join table, for works
#
# Table Variables
# --------------------------------------------------------------------------------
#  variable        | type        | about
# --------------------------------------------------------------------------------
#  id              | integer     | unique
#  work_id         | integer     | references work
#  tag_id          | integer     | references tag
#  created_at      | datetime    | <= updated_at
#  updated_at      | datetime    | >= created_at
# ================================================================================

class Tagging < ActiveRecord::Base

	# SCOPES
	# ------------------------------------------------------------
	scope :not_among_for, ->(item_id, tag_ids) { where("item_id = ? AND tag_id NOT IN (?)", item_id, tag_ids) }
	scope :are_among_for, ->(item_id, tag_ids) { where("item_id = ? AND tag_id IN (?)",     item_id, tag_ids) }

	# ASSOCIATIONS
	# ------------------------------------------------------------
	belongs_to :work
	belongs_to :tag

end
