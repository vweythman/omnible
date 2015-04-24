class Respondence < ActiveRecord::Base
  belongs_to :caller, :polymorphic => true
  belongs_to :response, :polymorphic => true
end
