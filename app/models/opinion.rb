# Opinion
# ================================================================================
# subpart of characters
#
# Table Variables
# --------------------------------------------------------------------------------
#  variable        | type        | about
# --------------------------------------------------------------------------------
#  id              | integer     | unique
#  character_id    | integer     | references character
#  recip_id        | integer     | references character
#  fondness        | integer     | scale column
#  respect         | integer     | scale column
#  about           | string      | can be null
#  created_at      | datetime    | must be earlier or equal to updated_at
#  updated_at      | datetime    | must be later or equal to created_at
# ================================================================================

class Opinion < ActiveRecord::Base

	# VALIDATIONS
	# ------------------------------------------------------------
	validates :recip_id, presence: true
	validates :fondness, presence: true
	validates :respect,  presence: true

	# SCOPES
	# ------------------------------------------------------------
	# - Collect
	scope :uniques, -> { select("fondness, respect, Count(*) as count").group("fondness, respect").order('fondness, respect')}

	# - Sums
	scope :summarize,        ->(column) { select("SUM(#{column}) as #{column}") }
	scope :aggregate,        -> { summarize("fondness").summarize("respect") }
	scope :aggreate_average, -> { select("SUM(fondness) / COUNT(*) as fondness, SUM(respect) / COUNT(*) as respect") }

	# - Associated
	scope :from_either, ->(c1, c2) { where("character_id = ? OR character_id = ?", c1.id, c2.id) }
	scope :to_either,   ->(c1, c2) { where("recip_id = ? OR recip_id = ?",         c1.id, c2.id) }
	scope :intersect,   ->(c1, c2) { aggregate.from_either(c1, c2).to_either(c1, c2) }

	# ASSOCIATIONS
	# ------------------------------------------------------------
	belongs_to :character, :inverse_of => :opinions
	belongs_to :recip,     class_name: "Character"

	# CLASS METHODS
	# ------------------------------------------------------------
	# Intersection - average the intersection of opinions between characters
	def self.intersection(left_character, right_character)
		avg = Opinion.intersect(left_character, right_character).first
		avg.fondness = (avg.fondness / 2.0).round
		avg.respect  = (avg.respect / 2.0).round
		return avg
	end

end
