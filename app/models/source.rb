# Source
# ================================================================================
# links
#
# Table Variables
# --------------------------------------------------------------------------------
#  variable        | type        | about
# --------------------------------------------------------------------------------
#  id              | integer     | unique
#  reference       | string      | cannot be null, must be valid link
#  host_id         | integer     | references host
#  created_at      | datetime    | <= updated_at
#  updated_at      | datetime    | >= created_at
#  reference_id    | integer     | polymorphic reference
#  reference_type  | string      | polymorphic reference
#  type            | string      | sti
# ================================================================================

class Source < ActiveRecord::Base

	# VALIDATIONS
	# ------------------------------------------------------------
	validates :reference, :url => true

	# ASSOCIATIONS
	# ------------------------------------------------------------
	belongs_to :referencer, :polymorphic => true

	# PUBLIC METHODS
	# ------------------------------------------------------------
	def pathing
		(reference.match /^https?:\/\//) ? reference : "http://#{reference}"
	end

end
