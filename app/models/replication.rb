class Replication < ActiveRecord::Base
  belongs_to :original, class_name: "Character"
  belongs_to :clone, class_name: "Character"
end
