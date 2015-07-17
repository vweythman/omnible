class Roleplayer < ActiveRecord::Base
  belongs_to :user
  belongs_to :character
end
