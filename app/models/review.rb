# Review
# ================================================================================
# scale for narrative works and users
#
# Table Variables
# --------------------------------------------------------------------------------
#  variable          | type      | about
# --------------------------------------------------------------------------------
#  id                | integer   | unique
#  work_id           | string    | references work
#  user_id           | string    | references user
#  plot              | integer   | between 0 and 4
#  characterization  | integer   | between 0 and 4
#  writing           | integer   | between 0 and 4
#  overall           | integer   | between 0 and 4
#  details           | text      | can be null
#  created_at        | datetime  | <= updated_at
#  updated_at        | datetime  | >= created_at
# ================================================================================

class Review < ActiveRecord::Base

  # ASSOCIATIONS
  # ------------------------------------------------------------
  belongs_to :work
  belongs_to :user

end
