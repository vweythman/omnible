# RecordMetadatum
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
#  value           | string      | length <= 250 characters
#  created_at      | datetime    | <= updated_at
#  updated_at      | datetime    | >= created_at
# ================================================================================

class RecordMetadatum < ActiveRecord::Base

	# MODULES
	# ============================================================
	extend Organizable
	extend DataDriven

	# VALIDATIONS
	# ============================================================
	#validates :work_id, presence: true
	validates :key,     presence: true
	validates :value,   presence: true
	validates_uniqueness_of :key, :scope => :work_id

	# CLASS METHODS
	# ============================================================
	def self.works_by_mediums
		RecordMetadatum.organize(RecordMetadatum.mediums.includes(:work => :quantitatives))
	end

	def self.works_by_medium(m)
		RecordMetadatum.by_medium(m).includes(:work => :quantitatives).map(&:work)
	end

	# SCOPES
	# ============================================================
	# Filters
	# ------------------------------------------------------------
	scope :by_value,  ->(v) { where(value: v) }
	scope :by_medium, ->(m) { mediums.by_value(m) }

	# Sorter
	# ------------------------------------------------------------
	scope :alphabetic, -> { order(:value) }

	# Subtype
	# ------------------------------------------------------------
	scope :first_chapter,   -> { where(key: "first-chapter")  }
	scope :lastest_chapter, -> { where(key: "latest-chapter") }
	scope :mediums,         -> { where(key: "medium")  }
	scope :medium,          -> { mediums.pluck(:value) }

	# ASSOCIATIONS
	# ============================================================
	belongs_to :work

	# PUBLIC METHODS
	# ============================================================
	# Type - defines the type name if it exists
	def nature
		self.value
	end

	# Linkable - grab what will be used when organizing
	def linkable
		self.work
	end

end
