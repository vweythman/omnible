class Note < ActiveRecord::Base

	# MODULES
	# ------------------------------------------------------------
	include Discussable

	# CALLBACKS
	# ------------------------------------------------------------
	after_create :set_discussion

	# ASSOCIATIONS
	# ------------------------------------------------------------
	belongs_to :work,     :inverse_of => :notes
	has_one    :topic,    :inverse_of => :discussed, as: :discussed
	has_many   :comments, :through => :discussion

	delegate :user, to: :work
	
	# METHODS
	# ------------------------------------------------------------
	# Heading
	# - defines the main means of addressing the model
	def heading
		if title.empty?
			"Note"
		else
			title
		end
	end

end
