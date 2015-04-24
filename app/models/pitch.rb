class Pitch < ActiveRecord::Base

	# ASSOCIATIONS
	# ------------------------------------------------------------
	# joins
	has_many :respondence, as: :caller

	# models that possess these models
	belongs_to :user

	# models that belong to this model
	has_many :responses, through: :respondences

end
