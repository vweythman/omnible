# Skin
# ================================================================================
# stylesheet skin
#
# Table Variables
# --------------------------------------------------------------------------------
#  variable name   | type        | about
# --------------------------------------------------------------------------------
#  id              | integer     | unique
#  uploader_id     | integer     | ref
#  style           | text        | req.
#  title           | string      | req.
#  status          | string      | req.
#  created_at      | datetime    | <= updated_at
#  updated_at      | datetime    | >= created_at
# ================================================================================

class Skin < ActiveRecord::Base

	# VALIDATIONS
	# ============================================================
	validates :title,       presence: true, length: { maximum: 250 }
	validates :uploader_id, presence: true
	validates :style,       presence: true
	validates :status,      presence: true, inclusion: { in: ['Public', 'Private'] }

	# SCOPES
	# ============================================================
	scope :general_use, -> { where(:status => 'Public')  }
	scope :private_use, -> { where(:status => 'Private') }

	# ASSOCIATIONS
	# ============================================================
	belongs_to :uploader, class_name: "User"
	has_many   :skinnings
	has_many   :works, through: :skinnings, :inverse_of => :skin

	# CLASS METHODS
	# ============================================================
	def self.statuses
		['Private', 'Public']
	end

	# PUBLIC METHODS
	# ============================================================
	def heading
		title
	end

	def editable?(user)
		uploader == user
	end

	def publicity
		"Private"
	end

	def editablity
		"Private"
	end

end
