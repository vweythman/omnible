module Discussable
	# SetDiscussion
	# - setup a discussion of the model
	def set_discussion
		if topic.nil?
			topic           = Topic.new
			topic.creator   = self.user
			topic.title     = "#{self.class.to_s} Discussion"
			topic.discussed = self
			topic.save
		end
	end
end
