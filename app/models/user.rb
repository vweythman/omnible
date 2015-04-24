# User
# ================================================================================
# [description]
#
# ================================================================================

class User < ActiveRecord::Base

	# VALIDATIONS and SCOPES
	# ------------------------------------------------------------
	validates :name, presence: true
	validates :email, presence: true

	# ASSOCIATIONS
	# ------------------------------------------------------------
	has_many :works

end
