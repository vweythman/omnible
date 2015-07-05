class Location < ActiveRecord::Base
  belongs_to :character
  belongs_to :place
end
