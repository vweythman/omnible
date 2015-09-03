# Roleplayer
# ================================================================================
# join table, users can roleplay characters
#
# Table Variables
# --------------------------------------------------------------------------------
#  variable     | type           | about
# --------------------------------------------------------------------------------
#  id           | integer        | unique
#  user_id      | integer        | references user
#  character_id | integer        | references character
#  created_at   | datetime       | <= updated_at
#  updated_at   | datetime       | >= created_at
# ================================================================================

class Roleplayer < ActiveRecord::Base
  belongs_to :user
  belongs_to :character
end
