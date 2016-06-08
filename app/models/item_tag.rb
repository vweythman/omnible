# ItemTag
# ================================================================================
# join table, tags items with qualities
#
# Table Variables
# --------------------------------------------------------------------------------
#  variable name   | type        | about
# --------------------------------------------------------------------------------
#  id              | integer     | unique
#  item_id         | integer     | references item
#  quality_id      | integer     | references user
#  created_at      | datetime    | must be earlier or equal to updated_at
#  updated_at      | datetime    | must be later or equal to created_at
# ================================================================================

class ItemTag < ActiveRecord::Base

	# SCOPES
	# ------------------------------------------------------------
	scope :not_among_for, ->(item_id, qualities_ids) { where("item_id = ? AND quality_id NOT IN (?)", item_id, qualities_ids)}
	scope :are_among_for, ->(item_id, qualities_ids) { where("item_id = ? AND quality_id IN (?)",     item_id, qualities_ids)}

	# ASSOCIATIONS
	# ------------------------------------------------------------
	belongs_to :item
	belongs_to :quality, class_name: "Tag"

end
