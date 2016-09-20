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

	# CALLBACKS
	# ------------------------------------------------------------
	after_create   :increment_metadata
	before_destroy :decrement_metadata

	# VALIDATIONS
	# ============================================================
	validates_uniqueness_of :tagged_id, :scope => :tagger_id

	# MODULES
	# ============================================================
	extend Organizable
	include CountableTagging

	# SCOPES
	# ============================================================
	# SUBTYPES
	# ------------------------------------------------------------
	scope :general,    -> { where(nature: "general")    }
	scope :set_in,     -> { where(nature: "setting")    }
	scope :cast_from,  -> { where(nature: "cast")       }
	scope :subject,    -> { where(nature: "subject")    }
	scope :referenced, -> { where(nature: "reference")  }

	# SELECT
	# ------------------------------------------------------------
	scope :tagger_with_works,         ->(ws)      { tagger_by_tag_titles(ws, :tagger_id, :work) }
	scope :tagger_with_grouped_works, ->(nat, ws) { where(nature: nat).tagger_with_works(ws)    }

	scope :with_tagged, -> { includes(:work) }
	scope :with_tagger, -> { includes(:tagging_work) }

	# ASSOCIATIONS
	# ============================================================
	# BELONGS TO
	# ------------------------------------------------------------
	belongs_to :work,         foreign_key: "tagged_id"
	belongs_to :tagging_work, foreign_key: "tagger_id", class_name: "Work"

	# SUBTYPES
	# ------------------------------------------------------------
	belongs_to :general_work,   -> { WorkConnection.general    }, class_name: "Work", foreign_key: "tagged_id"
	belongs_to :set_in_work,    -> { WorkConnection.set_in     }, class_name: "Work", foreign_key: "tagged_id"
	belongs_to :cast_from_work, -> { WorkConnection.cast_from  }, class_name: "Work", foreign_key: "tagged_id"
	belongs_to :work_subject,   -> { WorkConnection.subject    }, class_name: "Work", foreign_key: "tagged_id"
	belongs_to :work_reference, -> { WorkConnection.referenced }, class_name: "Work", foreign_key: "tagged_id"

	# CLASS METHODS
	# ============================================================
	# LABEL GROUPS
	# ------------------------------------------------------------
	def self.all_labels
		narrative_labels | nonfiction_labels
	end

	def self.labels(is_narrative)
		if is_narrative
			narrative_labels
		else
			nonfiction_labels
		end
	end

	def self.narrative_labels
		['general', 'setting', 'cast', 'reference']
	end

	def self.nonfiction_labels
		['subject', 'reference']
	end

	# LABEL HEADINGS
	# ------------------------------------------------------------
	def self.filter_labels
		@filter_labels ||= { "general" => "Works as Fandom", "setting" => "Works as Setting", "cast" => "Cast From These Works", "reference" => "Works as Reference", "subject" => "Works as Subject"}
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

	def self.work_tag_labels(work)
		labels = Hash.new

		if work.narrative?
			work_labels = narrative_labels
			work_labels.map {|lb| labels[lb] = "Works (#{lb.titleize})" }
		else
			work_labels = nonfiction_labels
			work_labels.map {|lb| labels[lb] = "#{lb.titleize} (Works)" }
		end

		return labels
	end

	# SQL
	# ------------------------------------------------------------
	def self.tagger_intersection_sql(finds)
		if (finds.keys - self.all_labels).empty?
			finds.map {|k, titles| WorkConnection.tagger_with_grouped_works(k.to_s, titles.split(";")).to_sql }.join(" INTERSECT ")
		else
			""
		end
	end

	# PUBLIC METHODS
	# ============================================================
	# Linkable - grab what will be used when organizing
	def linkable
		self.work
	end

	def base_metadata_key
		"taggings-count"
	end

	def metadata_key
		nature + "-" + base_metadata_key
	end

	def find_metadata_counter(key)
		c = RecordQuantitativeMetadatum.find_datum(self.tagged_id, key)
		c.value ||= 0
		c
	end

	# PRIVATE METHODS
	# ============================================================
	private

	def increment_metadata
		for_count = find_metadata_counter metadata_key
		for_count.value = for_count.value + 1
		for_count.save

		for_total = find_metadata_counter base_metadata_key
		for_total.value = for_total.value + 1
		for_total.save
	end

	def decrement_metadata
		for_count = find_metadata_counter metadata_key
		for_count.value = [for_count.value - 1, 0].max
		for_count.save

		for_total = find_metadata_counter base_metadata_key
		for_total.value = [for_count.value - 1, 0].max
		for_total.save
	end

end
