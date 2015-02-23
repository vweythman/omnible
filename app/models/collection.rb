class Collection < ActiveRecord::Base
  belongs_to :work
  belongs_to :anthology
end
