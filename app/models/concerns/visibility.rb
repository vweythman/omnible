require 'active_support/concern'

module Visibility
	extend ActiveSupport::Concern

	# CONSTANTS
	# ------------------------------------------------------------
	PERSONAL            = 0
	FRIENDS_ONLY        = 1
	FRIENDS_N_FOLLOWERS = 2
	MEMBERS_ONLY        = 3
	EXCEPT_BLOCKED      = 4
	PUBLIC              = 5

	included do
		scope :by_friends, ->(user, level) { where("publicity_level = #{FRIENDS_ONLY}", level)}

		has_many :edit_invites, dependent: :destroy, as: :editable
		has_many :view_invites, dependent: :destroy, as: :viewable
		has_many :invited_editors, through: :edit_invites, source: :user
		has_many :invited_viewers, through: :view_invites, source: :user
	end
end
