require 'active_support/concern'

module Editable
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

	# VARIABLES
	# ------------------------------------------------------------
	attr_accessor :reader
	attr_accessor :level

	# CLASS METHODS
	# ------------------------------------------------------------
	def self.levels
		['private', 'friends', 'friends & followers', 'users', 'mostly public', 'completely public']
	end

	# METHODS
	# ------------------------------------------------------------
	# Creator?
	# - reader is the creator
	def creator?(reader)
		self.uploader == reader
	end

	# Editable?
	# - asks if character can be edited
	def editable?(editor)
		@reader = editor
		@level  = self.editor_level
		creator?(@reader) || for_public? || invited_editor?(@reader) || check_restrictions
	end

	# InvitedEditor?
	# - viewer is on invite list
	def invited_editor?(editor)
		self.invited_editors.include?(editor)
	end
	# InvitedToView?
	# - viewer is on invite list
	def invited_viewer?(reader)
		self.invited_viewers.include?(reader)
	end

	# Unblocked?
	# - viewer is not banned from viewing
	def unblocked_access?(reader)
		!self.uploader.blocking?(reader)
	end

	# Viewable?
	# - asks if character is publically viewable or owned by 
	#   current user
	def viewable?(reader)
		@reader = reader
		@level  = self.publicity_level

		creator?(@reader) || for_public? || invited_viewer?(@reader) || check_restrictions
	end

	# PRIVATE METHODS
	# ------------------------------------------------------------
	private
	# ForPublicViewing?
	# - checks if publically viewable or semi-public
	def for_public?
		@level == Editable::PUBLIC
	end

	# CheckRestrictions
	# - checks various publicity levels
	def check_restrictions
		unblocked_access?(@reader) && (semi_public? || for_friendly? || for_following? || for_user?)
	end
	
	# ForFriendlyViewer
	# - allows viewing if reader is a friend
	def for_friendly?
		@level > Editable::PERSONAL && @level <= Editable::FRIENDS_N_FOLLOWERS && self.uploader.friend?(@reader)
	end

	# ForFollowingViewer
	# - allows viewing if reader is a follower
	def for_following?
		@level == Editable::FRIENDS_N_FOLLOWERS && self.uploader.follower?(@reader)
	end

	# ForViewingUser
	# - allows viewing if reader is a user of the site
	def for_user?
		@level == Editable::MEMBERS_ONLY && !@reader.nil
	end

	# SemiPublic?
	# - check if can be viewed
	def semi_public?
		@level == Editable::EXCEPT_BLOCKED
	end

end
