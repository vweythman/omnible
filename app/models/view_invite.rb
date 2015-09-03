# ViewInvite
# ================================================================================
# join table
#
# Table Variables
# --------------------------------------------------------------------------------
#  variable        | type        | about
# --------------------------------------------------------------------------------
#  id              | integer     | unique
#  user_id         | integer     | references user
#  viewable_id     | integer     | polymorphic reference
#  viewable_type   | string      | polymorphic reference
#  created_at      | datetime    | <= updated_at
#  updated_at      | datetime    | >= created_at
# ================================================================================

class ViewInvite < ActiveRecord::Base
  belongs_to :user
  belongs_to :viewable, :polymorphic => true
end
