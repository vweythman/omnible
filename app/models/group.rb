class Group < ActiveRecord::Base
	
	# MODULES
	# ------------------------------------------------------------
	include Documentable  # member of the subject group

	# ASSOCIATIONS
	# ------------------------------------------------------------
	# joins
	has_many :memberships

	# models that belong this model
	has_many :characters, through: :memberships

end
