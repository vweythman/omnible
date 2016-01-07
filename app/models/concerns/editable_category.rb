require 'active_support/concern'

module EditableCategory
	extend ActiveSupport::Concern

	# CLASS METHODS
	# ------------------------------------------------------------
	class_methods do
		def createable?(user)
			!user.nil? && user.manager?
		end
	end

	# PUBLIC METHODS
	# ------------------------------------------------------------
	def destroyable?(user)
		!user.nil? && user.site_owner?
	end

	def editable?(user)
		!user.nil? && user.staffer?
	end

end
