# Comment
# ================================================================================
# user interaction
#
# Table Variables
# --------------------------------------------------------------------------------
#  variable        | type        | about
# --------------------------------------------------------------------------------
#  id              | integer     | unique
#  content         | text        | cannot be null
#  topic_id        | integer     | references topic
#  creator_id      | integer     | polymorphic reference
#  creator_type    | integer     | polymorphic reference
#  parent_id       | integer     | references comment
#  lft             | integer     | for nested set
#  rgt             | integer     | for nested set
#  depth           | integer     | for nested set
#  children_count  | integer     | for nested set
#  created_at      | datetime    | must be earlier or equal to updated_at
#  updated_at      | datetime    | must be later or equal to created_at
# ================================================================================

class Comment < ActiveRecord::Base
	acts_as_nested_set
	belongs_to :topic
	belongs_to :creator, :polymorphic => true

	scope :ordered, -> { order('topic_id ASC, lft ASC, rgt DESC') }
	scope :chronological, -> { order("comments.created_at ASC") }
	scope :truncate_at, ->(depth) { where('depth <= ?', depth).includes(:topic, :creator) }

end
