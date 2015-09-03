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
	validate :linkable

	# ASSOCIATIONS
	# ------------------------------------------------------------
	belongs_to :host
	belongs_to :referencer, :polymorphic => true

	# PRIVATE METHODS
	# ------------------------------------------------------------
	private

	def linkable
		true
	end

end
