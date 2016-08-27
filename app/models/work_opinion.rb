# WorkOpinion
# ================================================================================
# user interaction
#
# Table Variables
# --------------------------------------------------------------------------------
#  variable        | type        | about
# --------------------------------------------------------------------------------
#  id              | integer     | unique
#  title           | string      | max: 250 characters
#  user_id         | integer     | reference
#  work_id         | integer     | reference
#  value           | integer     |
#  created_at      | datetime    | <= updated_at
#  updated_at      | datetime    | >= created_at
# ================================================================================

class WorkOpinion < ActiveRecord::Base

	belongs_to :work
	belongs_to :user

	scope :liked,    ->    { where("value > ?", 0) }
	scope :disliked, ->    { where("value < ?", 0) }

	scope :by_work, ->(w) { where(work_id: w.id) }
	scope :by_user, ->(u) { where(user_id: u.id) }

	scope :by_selectables, -> (u, w) { by_user(u).by_work(w) }

	def is_a_dislike?
		self.value < 0
	end

	def is_a_like?
		self.value > 0
	end

	def make_disliked
		self.value = -1
	end

	def make_liked
		self.value = 1
	end

end
