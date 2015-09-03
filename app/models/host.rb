# Host
# ================================================================================
# list of other websites
#
# Table Variables
# --------------------------------------------------------------------------------
#  variable        | type        | about
# --------------------------------------------------------------------------------
#  id              | integer     | unique
#  name            | string      | maximum of 250 characters
#  reference       | string      | should not be null
#  created_at      | datetime    | must be earlier or equal to updated_at
#  updated_at      | datetime    | must be later or equal to created_at
# ================================================================================

class Host < ActiveRecord::Base
end
