# Rating
# ================================================================================
# scale for works
# 
# Table Variables
# --------------------------------------------------------------------------------
#  variable        | type        | about
# --------------------------------------------------------------------------------
#  id              | integer     | unique
#  work_id         | string      | references work
#  violence        | integer     | between 0 and 4
#  sexuality       | integer     | between 0 and 4
#  language        | integer     | between 0 and 4
#  created_at      | datetime    | <= updated_at
#  updated_at      | datetime    | >= created_at
# ================================================================================

class Rating < ActiveRecord::Base

	# VALIDATIONS
	# ------------------------------------------------------------
	validates :violence,  length: { in: 0..4 }
	validates :sexuality, length: { in: 0..4 }
	validates :language,  length: { in: 0..4 }

	# SCOPES
	# ------------------------------------------------------------
	# - General
	scope :at_least, ->(level) { where("MAX(violence, sexuality, language) >= ?", level) }
	scope :at_most,  ->(level) { where("MAX(violence, sexuality, language) <= ?", level) }
	scope :between,  ->(min, max) { at_least(min).at_most(max) }

	# - Column Specific
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
	MEDIUM   = 2
	MAJOR    = 3
	EXPLICIT = 4

	# CLASS METHODS
	# ------------------------------------------------------------
	# Labels - collects the labels for each value
	def self.labels
		['Absent', 'Minor', 'Medium', 'Major', 'Explicit']
	end

	# Choose - find by range if it exists
	def self.choose(range = {})
		min    = range[:rating_min] || 0
		max    = range[:rating_max] || 4
		choice = range[:rating] || nil

		unless ['sexuality', 'language', 'violence'].include? choice
			choice = nil
		end

		choice.nil? ? between(min, max) : between_for(choice, min, max)
	end

	# PUBLIC METHODS
	# ------------------------------------------------------------
	# Heading - defines the main means of addressing the model
	def heading
		Rating.labels[self.max]
	end

	# HeadingSexuality - heading for Sexuality
	def heading_sexuality
		Rating.labels[self.sexuality] + " Sexuality"
	end

	# HeadingProfanity - heading for language
	def heading_profanity
		Rating.labels[self.language] + " Profanity"
	end

	# HeadingViolence - heading for violence
	def heading_violence
		Rating.labels[self.violence] + " Violence"
	end

	# Max - highest column value
	def max
		[self.violence, self.sexuality, self.language].max
	end

end
