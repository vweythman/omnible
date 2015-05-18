# Conception
# ================================================================================
# conception is a join model for works and concepts
#
# ================================================================================

class Conception < ActiveRecord::Base

	# ASSOCIATIONS
	# ------------------------------------------------------------
	belongs_to :work
	belongs_to :concept

end
