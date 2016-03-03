class StoryRoot < ActiveRecord::Base

	# ASSOCIATIONS
	# ============================================================
	belongs_to :story, class_name: "Work"
	belongs_to :trunk, class_name: "Branch"

	# NESTED ATTRIBUTION
	# ============================================================
	accepts_nested_attributes_for :trunk

	# CALLBACKS
	# ============================================================
	before_create :ensure_branch

	# PRIVATE METHODS
	# ============================================================
	private
	def ensure_branch
		self.trunk.story = self.story
		self.trunk.save
	end

end
