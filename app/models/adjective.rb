class Adjective < ActiveRecord::Base

	# VALIDATIONS
	# ------------------------------------------------------------
	validates :name, length: { maximum: 250 }, presence: true
	
	# ASSOCIATIONS
	# ------------------------------------------------------------
	has_many :qualities, :inverse_of => :adjective

end
