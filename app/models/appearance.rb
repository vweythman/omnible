class Appearance < ActiveRecord::Base
  belongs_to :work
  belongs_to :character

  def self.roles
  	['main', 'side', 'mentioned']
  end
end
