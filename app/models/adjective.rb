class Adjective < ActiveRecord::Base

	# ASSOCIATIONS
	# ------------------------------------------------------------
	has_many :adjectivations
	has_many :qualities, :through => :adjectivations

end
