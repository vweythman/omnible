module EditableTag

	def destroyable?(user)
		!user.nil? && user.manager?
	end

	def createable?(user)
		!user.nil? && user.staffer?
	end

	def editable?(user)
		!user.nil? && user.staffer?
	end

end
