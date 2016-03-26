# Record
# ================================================================================
# type of work
# see Work for table variables

class Record < Work

	# CALLBACKS
	# ============================================================
	before_create :set_categories

	# ASSOCIATIONS
	# ============================================================
	has_one :medium_datum, ->{ RecordMetadatum.mediums }, foreign_key: "work_id", class_name: "RecordMetadatum"

	# NESTED ATTRIBUTION
	# ============================================================
	accepts_nested_attributes_for :medium_datum

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
		searchable_metadata["medium"]
	end

	def searchable_metadata
		@searchable_metadata ||= Hash[self.metadata.map{|m| [m.key, m.value]}]
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
		self.status = 'unknown'
	end

end
