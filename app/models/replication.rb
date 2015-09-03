# Replication
# ================================================================================
# join table, characters can be based upon other characters
#
# Table Variables
# --------------------------------------------------------------------------------
#  variable        | type        | about
# --------------------------------------------------------------------------------
#  id              | integer     | unique
#  original_id     | integer     | references place
#  clone_id        | integer     | references place
#  created_at      | datetime    | <= updated_at
#  updated_at      | datetime    | >= created_at
# ================================================================================

class Replication < ActiveRecord::Base
  belongs_to :original, class_name: "Character"
  belongs_to :clone, class_name: "Character"
end
