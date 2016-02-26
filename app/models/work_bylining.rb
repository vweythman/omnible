class WorkBylining < ActiveRecord::Base
  belongs_to :creator_category, class_name: "CreatorCategory", foreign_key: "creator_id"
  belongs_to :describer,        class_name: "WorksTypeDescriber"
end
