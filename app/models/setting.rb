# Setting
# ================================================================================
# join table, tags works with places
#
# Table Variables
# --------------------------------------------------------------------------------
#  variable     | type           | about
# --------------------------------------------------------------------------------
#  id           | integer        | unique
#  work_id      | integer        | references work
#  place_id     | integer        | references place
#  created_at   | datetime       | must be earlier or equal to updated_at
#  updated_at   | datetime       | must be later or equal to created_at
# ================================================================================

class Setting < ActiveRecord::Base
  belongs_to :work
  belongs_to :place
end
