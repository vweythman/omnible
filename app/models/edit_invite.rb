class EditInvite < ActiveRecord::Base
  belongs_to :user
  belongs_to :editable, :polymorphic => true
end