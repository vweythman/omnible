# EditInvite
# ================================================================================
# join table
#
# Table Variables
# --------------------------------------------------------------------------------
#  variable        | type        | about
# --------------------------------------------------------------------------------
#  id              | integer     | unique
#  user_id         | integer     | references user
#  editable_id     | integer     | polymorphic reference
#  editable_type   | string      | polymorphic reference
#  created_at      | datetime    | <= updated_at
#  updated_at      | datetime    | >= created_at
# ================================================================================

class EditInvite < ActiveRecord::Base
  belongs_to :user
  belongs_to :editable, :polymorphic => true
end
