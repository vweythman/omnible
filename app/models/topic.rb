# Topics
# ================================================================================
# user interaction
#
# Table Variables
# --------------------------------------------------------------------------------
#  variable        | type        | about
# --------------------------------------------------------------------------------
#  id              | integer     | unique
#  title           | string      | max: 250 characters
#  creator_id      | integer     | polymorphic reference
#  creator_type    | string      | polymorphic reference
#  allow_response  | boolean     |
#  created_at      | datetime    | <= updated_at
#  updated_at      | datetime    | >= created_at
#  discussed_id    | integer     | polymorphic reference
#  discussed_type  | string      | polymorphic reference
# ================================================================================

class Topic < ActiveRecord::Base

	# ASSOCIATIONS
	# ------------------------------------------------------------
	belongs_to :discussed, :polymorphic => true, :inverse_of => :topic
	belongs_to :creator,   :polymorphic => true
	has_many   :comments

	# PUBLIC METHODS
	# ------------------------------------------------------------
	# Heading - defines the main means of addressing the model
	def heading
		if self.discussed_id.nil?
			self.title
		else
			"Comments"
		end
	end

	def full_heading
		if self.discussed_id.nil?
			self.title
		else
			"Comments about #{discussed.heading}" 
		end
	end

end
