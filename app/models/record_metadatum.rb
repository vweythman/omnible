# Relator
# ================================================================================
# categories for interconnections
#
# Table Variables
# --------------------------------------------------------------------------------
#  variable name   | type        | about
# --------------------------------------------------------------------------------
#  id              | integer     | unique
#  work_id         | interger    | references work
#  key             | string      | length <= 250 characters
#  value           | string      | length <= 250 characters
#  right_name      | string      | length <= 250 characters
#  created_at      | datetime    | <= updated_at
#  updated_at      | datetime    | >= created_at
# ================================================================================

class RecordMetadatum < ActiveRecord::Base

	validates_uniqueness_of :key, :scope => :work_id

	# SCOPES
	# ============================================================
	scope :mediums, -> { where(key: "medium") }
	scope :medium,  -> { mediums.pluck(:value).first }

	# ASSOCIATIONS
	# ============================================================
	belongs_to :work

end
