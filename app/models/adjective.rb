class Adjective < ActiveRecord::Base

	# ASSOCIATIONS
	# ------------------------------------------------------------
	has_many :qualities, :inverse_of => :adjective

end
