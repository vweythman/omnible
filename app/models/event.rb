# Event
# ================================================================================
# a type of subject
#
# Table Variables
# --------------------------------------------------------------------------------
#  variable        | type        | about
# --------------------------------------------------------------------------------
#  id              | integer     | unique
#  name            | string      | maximum of 250 characters
#  place_id        | integer     | references place
#  created_at      | datetime    | must be earlier or equal to updated_at
#  updated_at      | datetime    | must be later or equal to created_at
#  uploader_id     | integer     | references user
# ================================================================================

class Event < ActiveRecord::Base
  belongs_to :place
end
