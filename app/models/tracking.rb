# Tracking
# ================================================================================
# join table
#
# Table Variables
# --------------------------------------------------------------------------------
#  variable        | type        | about
# --------------------------------------------------------------------------------
#  id              | integer     | unique
#  user_id         | integer     | references user
#  tracked_id      | integer     | polymorphic reference
#  tracked_type    | string      | polymorphic reference
#  created_at      | datetime    | <= updated_at
#  updated_at      | datetime    | >= created_at
# ================================================================================

class Tracking < ActiveRecord::Base
  belongs_to :user
  belongs_to :tracked, polymorphic: true

  scope :by_selectables, -> (u, t) { by_user(u).by_tracked(t) }
  scope :by_user,        -> (u)    { where(user_id: u.id) }
  scope :by_tracked,     -> (t)    { where(tracked_id: t.id, tracked_type: t.class.base_class) }

end
