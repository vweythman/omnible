# Collection
# ================================================================================
# join table, anthologies has works
#
# Table Variables
# --------------------------------------------------------------------------------
#  variable        | type        | about
# --------------------------------------------------------------------------------
#  id              | integer     | unique
#  anthology_id    | integer     | references anthology
#  work_id         | integer     | references work
#  created_at      | datetime    | must be earlier or equal to updated_at
#  updated_at      | datetime    | must be later or equal to created_at
# ================================================================================

class Collection < ActiveRecord::Base

	# VALIDATIONS
	# ------------------------------------------------------------
	validates :anthology_id, presence: true
	validates :work_id,      presence: true
	validates_uniqueness_of :anthology_id, :scope => :work_id

	# ASSOCIATIONS
	# ------------------------------------------------------------
	belongs_to :work
	belongs_to :anthology

end
