# Note
# ================================================================================
# subpart of works
#
# Table Variables
# --------------------------------------------------------------------------------
#  variable        | type        | about
# --------------------------------------------------------------------------------
#  id              | integer     | unique
#  title           | string      | maximum of 250 characters
#  content         | text        | cannot be null
#  work_id         | integer     | cannot be null
#  created_at      | datetime    | must be earlier or equal to updated_at
#  updated_at      | datetime    | must be later or equal to created_at
# ================================================================================

class Note < ActiveRecord::Base

	# MODULES
	# ------------------------------------------------------------
	include Discussable

	# CALLBACKS
	# ------------------------------------------------------------
	after_create :set_discussion
	after_save :cascade_data

	# ASSOCIATIONS
	# ------------------------------------------------------------
	belongs_to :work

	# DELEGATED METHODS
	# ------------------------------------------------------------
	delegate :uploader, to: :work
	
	# METHODS
	# ------------------------------------------------------------
	# Heading - defines the main means of addressing the model
	def heading
		if title.empty?
			"Note"
		else
			title
		end
	end

	def cascade_data
		self.work.updated_at = self.updated_at
		self.work.save
	end

end
