# Record
# ================================================================================
# type of work
# see Work for table variables

class Record < Work

	# CALLBACKS
	# ============================================================
	before_create :set_categories

	# SCOPES
	# ============================================================
	scope :by_medium, ->(t) { joins(:qualitatives).merge(RecordMetadatum.by_medium(t)) }

	# ASSOCIATIONS
	# ============================================================
	has_one :medium_datum, ->{ RecordMetadatum.mediums }, foreign_key: "work_id", class_name: "RecordMetadatum"

	# NESTED ATTRIBUTION
	# ============================================================
	accepts_nested_attributes_for :medium_datum

	# CLASS METHODS
	# ============================================================
	def self.recorded(type)
		if type.nil?
			all
		else
			by_medium(t)
		end
	end

	# PUBLIC METHODS
	# ============================================================
	# QUESTIONS 
	# ------------------------------------------------------------
	def editable?(user)
		!user.nil? && user.admin?
	end

	def destroyable?(user)
		!user.nil? && user.admin?
	end

	def viewable?(user)
		true
	end

	# GETTERS 
	# ------------------------------------------------------------
	def tag_heading
		title + " [#{taggable_medium}]"
	end

	def medium
		medium_datum.value
	end

	def taggable_medium
		searchable_qualitative_metadata["medium"]
	end

	def mediumize
		if medium_datum.nil?
			medium_datum       = RecordMetadatum.new
			medium_datum.key   = "medium"
			medium_datum.value = "Unsorted"
		end
	end

	# PRIVATE METHODS
	# ============================================================
	private

	# set default categories
	def set_categories
		self.status ||= "unknown"
	end

end
