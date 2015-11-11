class Creatorship < ActiveRecord::Base
  belongs_to :user
  belongs_to :work
  belongs_to :category, class_name: "CreatorCategory", inverse_of: :creatorships
end
