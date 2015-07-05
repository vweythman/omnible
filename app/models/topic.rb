class Topic < ActiveRecord::Base
	belongs_to :discussed, :polymorphic => true, :inverse_of => :topic
	belongs_to :creator,   :polymorphic => true
	has_many   :comments

	def heading
		if self.discussed.nil?
			self.title
		else
			"Comments"
		end
	end

end
