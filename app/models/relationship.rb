# Relationship
# ================================================================================
# membership is a join model between characters and their relationship type
#
# ================================================================================

class Relationship < ActiveRecord::Base

  # VALIDATIONS and SCOPES
  # ------------------------------------------------------------
  scope :canon_relationship, -> { where(canon: '1') }
  scope :character_relationships, ->(person_id) { where("left_id = ? OR right_id = ?", person_id, person_id)}
  validates :left_id,    presence: true
  validates :right_id,   presence: true
  validates :relator_id, presence: true, :uniqueness => {:scope => [:left_id, :right_id]}

  # ASSOCIATIONS
  # ------------------------------------------------------------
  belongs_to :left, class_name: "Character"
  belongs_to :relator
  belongs_to :right, class_name: "Character"

end
