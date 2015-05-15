class ItemDescription < ActiveRecord::Base

	# SCOPES
	# ------------------------------------------------------------
	scope :not_among, ->(item_id, qualities_ids)   { where("item_id = ? AND quality_id NOT IN (?)", item_id, qualities_ids)}
	scope :is_included, ->(item_id, qualities_ids) { where("item_id = ? AND quality_id IN (?)",     item_id, qualities_ids)}

	# ASSOCIATIONS
	# ------------------------------------------------------------
	belongs_to :item
	belongs_to :quality

end
