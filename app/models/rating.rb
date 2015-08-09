# Rating
# ================================================================================
#
# --------------------------------------------------------------------------------
#  variable name   | type        | about
# --------------------------------------------------------------------------------
#  id              | integer     | 
#  work_id         | string      | 
#  violence        | integer     | between 0 and 4
#  sexuality       | integer     | between 0 and 4
#  language        | integer     | between 0 and 4
#  created_at      | datetime    | must be earlier or equal to updated_at
#  updated_at      | datetime    | must be later or equal to created_at
#
# ================================================================================

class Rating < ActiveRecord::Base

	# VALIDATIONS
	# ------------------------------------------------------------
	validates :violence,  length: { in: 0..4 }
	validates :sexuality, length: { in: 0..4 }
	validates :language,  length: { in: 0..4 }

	# SCOPES
	# ------------------------------------------------------------
	# - in general
	scope :at_least, ->(level) { where("MAX(violence, sexuality, language) >= ?", level) }
	scope :at_most,  ->(level) { where("MAX(violence, sexuality, language) <= ?", level) }
	scope :between,  ->(min, max) { at_least(min).at_most(max) }

	# - by specific column
	scope :at_least_for, ->(column, level) { where("? >= ?", column, level)}
	scope :at_most_for,  ->(column, level) { where("? <= ?", column, level)}
	scope :between_for,  ->(column, min, max) { at_least_for(column, min).at_most_for(column, max) }

	# ASSOCIATIONS
	# ------------------------------------------------------------
	belongs_to :work

	# CONSTANTS
	# ------------------------------------------------------------
	ABSENT   = 0
	MINOR    = 1
	MID      = 2
	MAJOR    = 3
	EXPLICIT = 4

	# CLASS METHODS
	# ------------------------------------------------------------
	def self.labels
		['Absent', 'Minor', 'Medial', 'Major', 'Explicit']
	end

	def self.choose(range = {})
		min = range[:rating_min] || 0
		max = range[:rating_max] || 4
		chc = range[:rating] || nil

		unless ['sexuality', 'language', 'violence'].include? chc
			chc = nil
		end

		chc.nil? ? between(min, max) : between_for(chc, min, max)
	end

	# PUBLIC METHODS
	# ------------------------------------------------------------
	def heading
		Rating.labels[self.max]
	end

	def max
		[self.violence, self.sexuality, self.language].max
	end

	def heading_sexuality
		Rating.labels[self.sexuality]
	end

	def heading_language
		Rating.labels[self.language]
	end

	def heading_violence
		Rating.labels[self.violence]
	end
end
