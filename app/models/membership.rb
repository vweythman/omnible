class Membership < ActiveRecord::Base
  belongs_to :cast
  belongs_to :character
  
  def self.roles
    ['included', 'associated']
  end
end
