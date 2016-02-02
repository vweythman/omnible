# Work
# ================================================================================
# creations
#
# Table Variables
# --------------------------------------------------------------------------------
#  variable name          | type        | about
# --------------------------------------------------------------------------------
#  id                     | integer     | unique
#  name                   | string      | max: 250 characters
#  is_narrative           | boolean     | default: true
#  is_singleton           | boolean     | default: true
#  content_type           | string      | max: 250 characters
#  is_record              | boolean     | default: false
#  is_creative_expression | boolean     | default: false
#  created_at             | datetime    | <= updated_at
#  updated_at             | datetime    | >= created_at
# ================================================================================

class WorksTypeDescriber < ActiveRecord::Base

	# SCOPES
	# ------------------------------------------------------------
	scope :fiction,    -> { where(is_creative_expression: true) }
	scope :nonfiction, -> { where(is_creative_expression: false) }

	scope :chaptered,  -> { where(is_singleton: false) }
	scope :oneshot,    -> { where(is_singleton: true) }

	scope :offsite,    -> { where(is_record: true) }
	scope :local,      -> { where(is_record: false) }

	scope :textual,    -> { where("content_type = 'text'") }
	scope :audible,    -> { where("content_type = 'video' OR content_type = 'audio'") }
	scope :visual,     -> { where("content_type = 'video' OR content_type = 'picture'") }

	scope :among,      ->(ids) { where("id IN (?)", ids) }

	# ASSOCIATIONS
	# ------------------------------------------------------------
	has_many                :works, foreign_key: "type", primary_key: "name"
	has_and_belongs_to_many :creator_categories, inverse_of: :works_type_describers

	# PUBLIC METHODS
	# ------------------------------------------------------------
	# Narrative? - fiction vs. non-fiction
	def narrative?
		self.is_narrative == 't' || self.is_narrative == true
	end

	def record?
		self.is_record == true
	end

	def heading
		name.underscore.humanize.titleize
	end

	def agentize(creator_category)
		unless creator_categories.include? creator_category
			creator_categories << creator_category
		end
	end

	def deagentize(creator_category)
		creator_categories.delete(creator_category)
	end

end
