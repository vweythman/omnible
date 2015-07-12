class Block < ActiveRecord::Base
  belongs_to :blocker, class_name: "User"
  belongs_to :blocked, class_name: "User"
end
