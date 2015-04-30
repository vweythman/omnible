class Adjectivation < ActiveRecord::Base
	# VALIDATIONS and SCOPES
	# ------------------------------------------------------------
	scope :is_included, ->(quality_id, adjective_ids) { where("quality_id = ? AND adjective_id IN (?)",     quality_id, adjective_ids)}
	scope :not_among, ->(quality_id, adjective_ids)   { where("quality_id = ? AND adjective_id NOT IN (?)", quality_id, adjective_ids)}

	# ASSOCIATIONS
	# ------------------------------------------------------------
	belongs_to :quality
	belongs_to :adjective

end
