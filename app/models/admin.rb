class Admin < ActiveRecord::Base

	# CONSTANTS
	# ------------------------------------------------------------
	OWNER   = 0
	MANAGER = 1
	STAFF   = 2
	TESTER  = 3
	
	# ASSOCIATIONS
	# ------------------------------------------------------------
	belongs_to :user

	# PUBLIC METHODS
	# ------------------------------------------------------------
	def site_owner?
		permission_level == Admin::OWNER
	end

	def manager?
		permission_level == Admin::MANAGER
	end

	def staffer?
		permission_level == Admin::STAFF
	end

	def tester?
		permission_level == Admin::TESTER
	end

end
