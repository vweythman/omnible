class Note < ActiveRecord::Base

	# ASSOCIATIONS
	# ------------------------------------------------------------
	belongs_to :work, :inverse_of => :notes

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
