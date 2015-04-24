# Collection
# ================================================================================
# collection is a join model for works and anthologies
#
# ================================================================================

class Collection < ActiveRecord::Base

	# VALIDATIONS and SCOPES
	# ------------------------------------------------------------
	validates :anthology_id, presence: true
	validates :work_id,      presence: true
	validates_uniqueness_of :anthology_id, :scope => :work_id

	# ASSOCIATIONS
	# ------------------------------------------------------------
	belongs_to :work
	belongs_to :anthology

end
