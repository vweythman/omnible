class Friendship < ActiveRecord::Base
  belongs_to :friender, class_name: "User"
  belongs_to :friendee, class_name: "User"

  scope :mutual,     ->{ where(is_mutual: 't') }
  scope :unrequited, ->{ where(is_mutual: 'f') }
end
