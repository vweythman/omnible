class ItemTag < ActiveRecord::Base

	# SCOPES
	# ------------------------------------------------------------
	scope :not_among_for, ->(item_id, qualities_ids) { where("item_id = ? AND quality_id NOT IN (?)", item_id, qualities_ids)}
	scope :are_among_for, ->(item_id, qualities_ids) { where("item_id = ? AND quality_id IN (?)",     item_id, qualities_ids)}

	# ASSOCIATIONS
	# ------------------------------------------------------------
	belongs_to :item
	belongs_to :quality

end
