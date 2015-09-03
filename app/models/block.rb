# Block
# ================================================================================
# user anti-interaction, join table
#
# Table Variables
# --------------------------------------------------------------------------------
#  variable     | type           | about
# --------------------------------------------------------------------------------
#  id           | integer        | unique
#  blocker_id   | interger       | references user
#  blocked_id   | integer        | references user
#  created_at   | datetime       | must be earlier or equal to updated_at
#  updated_at   | datetime       | must be later or equal to created_at
# ================================================================================

class Block < ActiveRecord::Base
  belongs_to :blocker, class_name: "User"
  belongs_to :blocked, class_name: "User"
end
