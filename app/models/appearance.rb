class Appearance < ActiveRecord::Base
  belongs_to :work
  belongs_to :character

  def self.top_characters
  end

  def self.top_works
  end

  def self.roles
  	['main', 'side', 'mentioned']
  end
end
