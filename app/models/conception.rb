# Conception
# ================================================================================
# conception is a join model for works and concepts
#
# ================================================================================

class Conception < ActiveRecord::Base

	# VALIDATIONS and SCOPES
	# ------------------------------------------------------------
	validates :work_id,    presence: true
	validates :concept_id, presence: true
	validates_uniqueness_of :concept_id, :scope => :work_id

	# ASSOCIATIONS
	# ------------------------------------------------------------
	belongs_to :work
	belongs_to :concept

end
