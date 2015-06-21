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
# Methods (max length: 25 characters) 
# --------------------------------------------------------------------------------
#  method name                 | output type | description
# --------------------------------------------------------------------------------
#  self.warmths                | list        | defines and collects @warmth levels
#  self.respects               | list        | defines and collects @respect 
#                              |             | levels
# ================================================================================

class Viewpoint < ActiveRecord::Base

  # VALIDATIONS
  # ------------------------------------------------------------
  validates :character_id, presence: true
  validates :recip_id,     presence: true
  validates :recip_type,   presence: true
  validates :warmth,       presence: true
  validates :respect,      presence: true

  # SCOPES
  # ------------------------------------------------------------
  scope :summed_likes,    -> { select("SUM(warmth) as warmth") }
  scope :summed_respects, -> { select("SUM(respect) as respect") }
  scope :summations, -> { select("SUM(warmth) as warmth, SUM(respect) as respect") }
  scope :prejudices, -> { where(recip_type: 'Identity') } 
  scope :opinions,   -> { where(recip_type: 'Character') }

  # ASSOCIATIONS
  # ------------------------------------------------------------
  belongs_to :holder, class_name: "Character", :inverse_of => :viewpoints
  belongs_to :recip, :polymorphic => true

  # METHODS
  # ------------------------------------------------------------
  def recip_heading
    recip_type == "Identity" ? recip.name.titleize.pluralize : recip.name
  end

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
