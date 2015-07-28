require 'active_support/concern'

module Discussable
	extend ActiveSupport::Concern

	included do
		has_one  :topic,    :inverse_of => :discussed, as: :discussed
		has_many :comments, :through => :discussion
	end

	# SetDiscussion - setup a discussion of the model
	def set_discussion
		if topic.nil?
			topic           = Topic.new
			topic.creator   = self.uploader
			topic.title     = "#{self.class.to_s} Discussion"
			topic.discussed = self
			topic.save
		end
	end
end
