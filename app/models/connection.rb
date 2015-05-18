# Connection
# ================================================================================
# membership is a join model between characters and their connection type
#
# ================================================================================

class Connection < ActiveRecord::Base

  # VALIDATIONS and SCOPES
  # ------------------------------------------------------------
  scope :canon_connection, -> { where(canon: '1') }
  scope :character_connections, ->(person_id) { where("left_id = ? OR right_id = ?", person_id, person_id)}
  
  # ASSOCIATIONS
  # ------------------------------------------------------------
  belongs_to :left, class_name: "Character"
  belongs_to :relator
  belongs_to :right, class_name: "Character"

end
