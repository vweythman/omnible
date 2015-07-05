class Setting < ActiveRecord::Base
  belongs_to :work
  belongs_to :place
end
