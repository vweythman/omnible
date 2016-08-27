# Respondence
# ================================================================================
# join table, responses are created
#
# Table Variables
# --------------------------------------------------------------------------------
#  variable        | type        | about
# --------------------------------------------------------------------------------
#  id              | integer     | unique
#  caller_id       | integer     | polymorphic reference
#  caller_type     | string      | polymorphic reference
#  response_id     | interger    | references work
#  role            | string      | cannot be null
#  created_at      | datetime    | <= updated_at
#  updated_at      | datetime    | >= created_at
# ================================================================================

class Respondence < ActiveRecord::Base
  belongs_to :caller, polymorphic: true
  belongs_to :response, class_name: "Work"
end
