# Tagging
# ================================================================================
# join table, for works
#
# Table Variables
# --------------------------------------------------------------------------------
#  variable        | type        | about
# --------------------------------------------------------------------------------
#  id              | integer     | unique
#  tagger_id       | integer     | reference
#  tagger_type     | string      | reference
#  form            | string      | 
#  tag_id          | integer     | references tag
#  created_at      | datetime    | <= updated_at
#  updated_at      | datetime    | >= created_at
# ================================================================================

class Tagging < ActiveRecord::Base

	# MODULES
	# ============================================================
	extend Organizable
	include CountableTagging

	# VALIDATIONS
	# ============================================================
	validates :tag_id, uniqueness: { scope: [:tagger_id, :tagger_type] }

	# SCOPES
	# ============================================================
	# SELECT
	# ------------------------------------------------------------
	scope :not_among, ->(tag_ids) { where("tag_id NOT IN (?)", tag_ids) }
	scope :are_among, ->(tag_ids) { where("tag_id IN (?)",     tag_ids) }

	# SUBTYPES
	# ------------------------------------------------------------
	scope :chatter, -> { where(form: "commentary") }
	scope :general, -> { where(form: "general") }
	scope :warning, -> { where(form: "warning") }
	scope :quality, -> { where(form: "quality") }
	scope :genre,   -> { where(form: "genre") }

	# SELECT
	# ------------------------------------------------------------
	scope :tagger_by_tag,         ->(ws, tgr_type) { tagger_by_tag_names(ws, :tagger_id, :tag).where(tagger_type: tgr_type) }
	scope :tagger_by_grouped_tag, ->(nat, ws, tgr_type) { where(form: nat).tagger_by_tag(ws, tgr_type) }

	scope :with_tag, -> { includes(:tag) }

	# ASSOCIATIONS
	# ============================================================
	# BELONGS TO
	# ------------------------------------------------------------
	belongs_to :tagger, polymorphic: true
	belongs_to :tag

	# SUBTYPES
	# ------------------------------------------------------------
	belongs_to :chatter_tag, -> { Tagging.chatter }, class_name: "Tag", foreign_key: "tag_id"
	belongs_to :general_tag, -> { Tagging.general }, class_name: "Tag", foreign_key: "tag_id"
	belongs_to :warning_tag, -> { Tagging.warning }, class_name: "Tag", foreign_key: "tag_id"
	belongs_to :quality_tag, -> { Tagging.quality }, class_name: "Tag", foreign_key: "tag_id"
	belongs_to :genre_tag,   -> { Tagging.genre   }, class_name: "Tag", foreign_key: "tag_id"

	# CLASS METHODS
	# ============================================================
	# LABEL GROUPS
	# ------------------------------------------------------------
	def self.work_labels
		['general', 'genre', 'warning', 'commentary']
	end

	def self.subject_labels
		['quality']
	end

	def self.specific_labels(ltype="Subject")
		if ltype == "Work"
			work_labels
		else
			subject_labels
		end
	end

	# LABEL HEADINGS
	# ------------------------------------------------------------
	def self.work_filter_labels
		@filter_labels ||= { "general" => "General Tags", "genre" => "Genre Tags", "warning" => "Content Warnings" }
	end

	def self.work_tag_labels(work)
		labels = Hash.new

		if work.narrative?
			work_labels.map {|lb| labels[lb] = "#{lb.titleize} Tags"}
		else
			work_labels.map {|lb| labels[lb] = "Subject (#{lb.titleize})"}
		end

		return labels
	end

	# SQL
	# ------------------------------------------------------------
	def self.tagger_intersection_sql(finds, tagger_type = "Subject")
		if (finds.keys - Tagging.specific_labels(tagger_type)).empty?
			finds.map {|k, titles| Tagging.tagger_by_grouped_tag(k.to_s, titles.split(";"), tagger_type).to_sql }.join(" INTERSECT ")
		else
			""
		end
	end

	# PUBLIC METHODS
	# ============================================================
	# Type - defines the type name if it exists
	def nature
		self.form
	end

	# Linkable - grab what will be used when organizing
	def linkable
		self.tag
	end

end
