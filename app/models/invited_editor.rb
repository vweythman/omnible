class InvitedEditor < ActiveRecord::Base
  belongs_to :user
  belongs_to :editable
end
