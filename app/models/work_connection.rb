# WorkConnection
# ================================================================================
# join table, tags works with works
#
# Table Variables
# --------------------------------------------------------------------------------
#  variable     | type           | about
# --------------------------------------------------------------------------------
#  id           | integer        | unique
#  tagged_id    | interger       | references work
#  tagger_id    | integer        | references work
#  nature       | string         | cannot be null
#  created_at   | datetime       | must be earlier or equal to updated_at
#  updated_at   | datetime       | must be later or equal to created_at
# ================================================================================

class WorkConnection < ActiveRecord::Base

	# VALIDATIONS
	# ============================================================
	validates_uniqueness_of :tagged_id, :scope => :tagger_id

	# MODULES
	# ============================================================
	extend Organizable

	# SCOPES
	# ============================================================
	# SUBTYPES
	# ------------------------------------------------------------
	scope :general,    -> { where(nature: "general") }
	scope :set_in,     -> { where(nature: "setting")    }
	scope :cast_from,  -> { where(nature: "characters") }
	scope :mentioned,  -> { where(nature: "mentioned")  }
	scope :subject,    -> { where(nature: "subject")    }

	# ASSOCIATIONS
	# ============================================================
	# BELONGS TO
	# ------------------------------------------------------------
	belongs_to :work,         foreign_key: "tagged_id"
	belongs_to :tagging_work, foreign_key: "tagger_id", class_name: "Work"

	# SUBTYPES
	# ------------------------------------------------------------
	belongs_to :general_work,   -> { WorkConnection.general   },  class_name: "Work", foreign_key: "tagged_id"
	belongs_to :set_in_work,    -> { WorkConnection.set_in    },  class_name: "Work", foreign_key: "tagged_id"
	belongs_to :cast_from_work, -> { WorkConnection.cast_from },  class_name: "Work", foreign_key: "tagged_id"
	belongs_to :mentioned_work, -> { WorkConnection.mentioned },  class_name: "Work", foreign_key: "tagged_id"
	belongs_to :work_subject,   -> { WorkConnection.subject   },  class_name: "Work", foreign_key: "tagged_id"

	# CLASS METHODS
	# ============================================================
	def self.labels(is_narrative)
		if is_narrative
			['main', 'setting', 'characters', 'mentioned']
		else
			['subject']
		end
	end

	def self.narrative_labels
		['main', 'setting', 'characters', 'mentioned']
	end

	def self.nonfiction_labels
		['subject']
	end

	def self.tag_labels(work)
		if work.narrative?
			labels = narrative_labels
			labels.map { |label|
				{
					:label   => label,
					:heading => "Works (#{label.titleize})"
				}
			}
		else
			labels = nonfiction_labels
			labels.map { |label|
				{
					:label   => label,
					:heading => "#{label.titleize} (Works)"
				}
			}
		end
	end

	# PUBLIC METHODS
	# ============================================================
	# Linkable - grab what will be used when organizing
	def linkable
		self.work
	end

end
