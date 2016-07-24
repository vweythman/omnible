# RecordQuantitativeMetadatum
# ================================================================================
# metadata
#
# Table Variables
# --------------------------------------------------------------------------------
#  variable name   | type        | about
# --------------------------------------------------------------------------------
#  id              | integer     | unique
#  work_id         | interger    | references work
#  key             | string      | length <= 250 characters
#  value           | interger    | 
#  created_at      | datetime    | <= updated_at
#  updated_at      | datetime    | >= created_at
# ================================================================================

class RecordQuantitativeMetadatum < ActiveRecord::Base

	# MODULES
	# ============================================================
	extend DataDriven

	# VALIDATIONS
	# ============================================================
	validates :work_id, presence: true
	validates :key,     presence: true
	validates :value,   presence: true
	validates_uniqueness_of :key, :scope => :work_id

	# SCOPES
	# ============================================================
	# Filter
	# ------------------------------------------------------------
	scope :by_value,         ->(v) { where(value: v) }
	scope :by_chapter_count, ->(m) { chapter_count.by_value(m) }

	# Sort
	# ------------------------------------------------------------
	scope :alphabetic, -> { order(:value) }

	# Subtype
	# ------------------------------------------------------------
	scope :chapter_counts, -> { where(key: "chapter-count") }
	scope :chapter_count,  -> { chapter_count.pluck(:value) }

	# ASSOCIATIONS
	# ============================================================
	belongs_to :work

end
