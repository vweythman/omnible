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

	# VALIDATIONS
	# ============================================================
	validates :name, uniqueness: true

	# SCOPES
	# ============================================================
	scope :fiction,    -> { where("status IN ('Fictional Narrative', 'Creative Expression')") }
	scope :nonfiction, -> { where(status: "Nonfiction") }
	scope :narrative,  -> { where(status: "Fictional Narrative") }

	scope :chaptered,  -> { where(is_singleton: false) }
	scope :oneshot,    -> { where(is_singleton: true) }

	scope :offsite, -> { where(is_record: true)  }
	scope :onsite,  -> { where(is_record: false) }

	scope :textual,     -> { where("content_type = 'text'")      }
	scope :audible,     -> { where("content_type = 'audio'")     }
	scope :audiovisual, -> { where("content_type = 'video'")     }
	scope :linkable,    -> { where("content_type = 'reference'") }
	scope :visual,      -> { where("content_type = 'picture'")   }
	scope :evidential,  -> { where("content_type = 'data'")      }

	scope :among,      ->(ids) { where("id IN (?)", ids) }
	scope :by_content, ->(t)   { where(content_type: t)  }

	# ASSOCIATIONS
	# ============================================================
	has_many :works,          foreign_key: "type",         primary_key: "name"
	has_many :work_bylinings, foreign_key: "describer_id", primary_key: "id"
	has_many :uploaders, ->{uniq}, through: :works
	has_many :creator_categories,  through: :work_bylinings

	# PUBLIC METHODS
	# ============================================================
	def self.offsite_sql
		WorksTypeDescriber.offsite.select(:name).to_sql
	end

	# PUBLIC METHODS
	# ============================================================
	# ACTIONS
	# ------------------------------------------------------------
	def agentize(creator_category)
		unless creator_categories.include? creator_category
			creator_categories << creator_category
		end
	end

	def deagentize(creator_category)
		creator_categories.delete(creator_category)
	end

	# GETTERS
	# ------------------------------------------------------------
	def heading
		name.underscore.humanize.titleize
	end

	# QUESTIONS
	# ------------------------------------------------------------
	# Narrative? - fiction vs. non-fiction
	def narrative?
		self.status == "Fictional Narrative"
	end

	def record?
		self.is_record == true
	end

	def oneshot?
		self.is_singleton == true
	end

	def onsite_multishot?
		self.is_singleton == false && self.is_record == false
	end

	def textual?
		content_type == 'text'
	end

	def trackable?
		!oneshot? || textual?
	end

end
