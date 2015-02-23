class Relationship < ActiveRecord::Base
  belongs_to :left, class_name: "Character"
  belongs_to :relator
  belongs_to :right, class_name: "Character"


  scope :canon_relationship, -> { where(canon: '1') }
end
