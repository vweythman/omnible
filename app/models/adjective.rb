# Adjective
# ================================================================================
# categories for qualities
#
# Table Variables
# --------------------------------------------------------------------------------
#  variable     | type           | about
# --------------------------------------------------------------------------------
#  id           | integer        | unique
#  name         | string         | maximum of 250 characters
#  created_at   | datetime       | must be earlier or equal to updated_at
#  updated_at   | datetime       | must be later or equal to created_at
# ================================================================================

class Adjective < ActiveRecord::Base

	# VALIDATIONS
	# ------------------------------------------------------------
	validates :name, length: { maximum: 250 }, presence: true
	
	# ASSOCIATIONS
	# ------------------------------------------------------------
	has_many :qualities, :inverse_of => :adjective

end
