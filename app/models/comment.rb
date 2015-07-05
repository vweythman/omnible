class Comment < ActiveRecord::Base
	acts_as_nested_set
	belongs_to :topic
	belongs_to :creator, :polymorphic => true
end
