# Viewpoint
# ================================================================================
# viewpoints are part of the rateable group
#
# Variables (max length: 15 characters) 
# --------------------------------------------------------------------------------
#  variable name   | type        | about
# --------------------------------------------------------------------------------
#  id              | integer     | unique,
#  character_id    | string      | links to character
#  recip_id        | integer     | links polymorphically
#  recip_type      | string      | character || identity
#  warmth          | integer     | default = 0
#  respect         | integer     | default = 0
#  about           | text        | can be null
#  created_at      | datetime    | must be earlier or equal to updated_at
#  updated_at      | datetime    | must be later or equal to created_at
#
# Model Associations
# --------------------------------------------------------------------------------
# owned by  : character
# refrences : recip (character || identity)
# 
# Methods (max length: 25 characters) 
# --------------------------------------------------------------------------------
#  method name                 | output type | description
# --------------------------------------------------------------------------------
#  self.warmth                 | list        | defines and collects @warmth levels
#  self.respect                | list        | defines and collects @respect 
#                              |             | levels
# ================================================================================

class Viewpoint < ActiveRecord::Base

  # VALIDATIONS and SCOPES
  # ------------------------------------------------------------
  validates :character_id, presence: true
  validates :recip_id,     presence: true
  validates :recip_type,   presence: true, :uniqueness => {:scope => [:character_id, :recip_type]}
  validates :warmth,       presence: true
  validates :respect,      presence: true
  scope :prejudices, -> { where(recip_type: 'Identity') } 
  scope :opinions,   -> { where(recip_type: 'Character') }

  # ASSOCIATIONS
  # ------------------------------------------------------------
  belongs_to :character
  belongs_to :recip, :polymorphic => true

  # METHODS
  # ------------------------------------------------------------
  # none yet

  # CLASS METHODS
  # ------------------------------------------------------------
  # warmths
  # - defines and collects names associated with @warmth
  def self.warmths
  	['Lowest', 'Low', 'Neutral', 'High', 'Highest']
  end

  # respects
  # - defines and collects names associated with @respect
  def self.respects
    ['Lowest', 'Low', 'Neutral', 'High', 'Highest']
  end

end
