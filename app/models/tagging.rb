class Tagging < ActiveRecord::Base

	# SCOPES
	# ------------------------------------------------------------
	scope :not_among, ->(item_id, tag_ids) { where("item_id = ? AND tag_id NOT IN (?)", item_id, tag_ids) }
	scope :are_among, ->(item_id, tag_ids) { where("item_id = ? AND tag_id IN (?)",     item_id, tag_ids) }

	# ASSOCIATIONS
	# ------------------------------------------------------------
	belongs_to :work
	belongs_to :tag

end
