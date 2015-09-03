# Possession
# ================================================================================
# join table, tags characters with items
#
# Table Variables
# --------------------------------------------------------------------------------
#  variable        | type        | about
# --------------------------------------------------------------------------------
#  id              | integer     | unique
#  character_id    | integer     | references character
#  item_id         | integer     | references item
#  created_at      | datetime    | must be earlier or equal to updated_at
#  updated_at      | datetime    | must be later or equal to created_at
#  type            | string      | 
# ================================================================================

class Possession < ActiveRecord::Base
  belongs_to :character
  belongs_to :item
end
