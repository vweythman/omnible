class ViewInvite < ActiveRecord::Base
  belongs_to :user
  belongs_to :viewable, :polymorphic => true
end
