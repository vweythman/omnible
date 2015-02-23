class Viewpoint < ActiveRecord::Base
  belongs_to :character
  belongs_to :recip, :polymorphic => true

  scope :prejudices, -> { where(recip_type: 'Identity') } 
  scope :opinions, -> { where(recip_type: 'Character') } 

  def self.warmths
  	['Very Low', 'Low', 'Neutral', 'High', 'Very High']
  end

  def self.respects
    ['Very Low', 'Low', 'Neutral', 'High', 'Very High']
  end
end
