class Skin < ActiveRecord::Base

	# SCOPES
	# ------------------------------------------------------------
	scope :general_use, -> { where(:status => 'Public') }
	scope :private_use, -> { where(:status => 'Private')}

	# ASSOCIATIONS
	# ------------------------------------------------------------
	belongs_to :uploader, class_name: "User"
	has_many   :skinnings
	has_many   :works, through: :skinnings, :inverse_of => :skin


	# CLASS METHODS
	# ------------------------------------------------------------
	def self.statuses
		['Private', 'Public']
	end

	# PUBLIC METHODS
	# ------------------------------------------------------------
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
