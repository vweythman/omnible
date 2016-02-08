require 'active_support/concern'

module Editable
	extend ActiveSupport::Concern

	# CONSTANT TYPES
	# ------------------------------------------------------------
	# - ADMIN
	MANAGER = -2
	STAFF   = -1

	# - USER
	PRIVATE  = 0
	PERSONAL = 0

	# - RELATED USERS
	FRIENDS_ONLY        = 1
	FRIENDS_N_FOLLOWERS = 2

	# - GENERAL PUBLIC
	EXCEPT_BLOCKED = 3
	MEMBERS_ONLY   = 4
	PUBLIC         = 5

	# SCOPES AND ASSOCIATIONS
	# ------------------------------------------------------------
	included do
		# SCOPES
		# - Levels of Visibility
		scope :public_viewable, -> { where("#{self.table_name}.publicity_level = ?", PUBLIC) }
		scope :semi_viewable,   -> { where("#{self.table_name}.publicity_level = ?", EXCEPT_BLOCKED) }
		scope :user_viewable,   -> { where("#{self.table_name}.publicity_level = ?", MEMBERS_ONLY)}
		scope :friend_viewable, -> { where("#{self.table_name}.publicity_level >= ? AND #{self.table_name}.publicity_level <= ?", FRIENDS_ONLY, FRIENDS_N_FOLLOWERS) }
		scope :follow_viewable, -> { where("#{self.table_name}.publicity_level = ?", FRIENDS_N_FOLLOWERS) }

		# - Conditional Scopes
		scope :for_anons,     -> { where("#{self.table_name}.publicity_level >= ?", PUBLIC) }
		scope :unblocked_for, ->(user) { where("#{self.table_name}.uploader_id NOT IN (SELECT blocker_id FROM blocks WHERE blocked_id = ?)",    user.id).semi_viewable }
		scope :friendlisted,  ->(user) { where("#{self.table_name}.uploader_id IN (SELECT friender_id FROM friendships WHERE friendee_id = ?)", user.id).friend_viewable }
		scope :followlisted,  ->(user) { where("#{self.table_name}.uploader_id IN (SELECT followed_id FROM followings WHERE follower_id = ?)",  user.id).follow_viewable.unblocked_for(user) }

		# ASSOCIATIONS
		# - Joins
		has_many :edit_invites, dependent: :destroy, as: :editable
		has_many :view_invites, dependent: :destroy, as: :viewable

		# - Has
		belongs_to :uploader, class_name: "User"
		has_many :invited_editors, through: :edit_invites, source: :user
		has_many :invited_viewers, through: :view_invites, source: :user
	end

	# VARIABLES
	# ------------------------------------------------------------
	attr_accessor :reader
	attr_accessor :level

	# CLASS METHODS
	# ------------------------------------------------------------
	class_methods do
		def viewable_for(user)
			if user.nil?
				for_anons
			else
				i = user.id
				user_is_uploader = "#{self.table_name}.uploader_id = #{i}"
				work_is_public   = "#{self.table_name}.publicity_level = #{PUBLIC}"
				membership_only  = "#{self.table_name}.publicity_level = #{MEMBERS_ONLY}"
				user_is_blocked  = "#{self.table_name}.uploader_id NOT IN (SELECT blocked_id FROM blocks WHERE blocker_id = #{i})"
				user_is_blocker  = "#{self.table_name}.uploader_id NOT IN (SELECT blocker_id FROM blocks WHERE blocked_id = #{i})"
				except_blocked   = "#{self.table_name}.publicity_level = #{EXCEPT_BLOCKED}"
				for_friends      = "#{self.table_name}.publicity_level > #{FRIENDS_ONLY - 1} AND #{self.table_name}.publicity_level < #{FRIENDS_N_FOLLOWERS + 1} AND #{self.table_name}.uploader_id IN (SELECT friender_id FROM friendships WHERE friendee_id = #{i})"
				for_followers    = "#{self.table_name}.publicity_level = #{FRIENDS_N_FOLLOWERS} AND #{self.table_name}.uploader_id IN (SELECT followed_id FROM followings WHERE follower_id = #{i})"

				# REPLACE WITH OR CHAINING EVENTUALLY
				self.where("
					#{user_is_uploader} OR #{work_is_public} OR #{membership_only} OR 
					(
						#{user_is_blocked} AND #{user_is_blocker} AND 
						(#{except_blocked} OR #{for_friends} OR #{for_followers})
					)"
				)
			end
		end
	end

	def self.labels
		['Private', 'Friends', 'Friends & Followers', 'Site Members (excluding blocked and blocking users)', 'Must Be Signed In', 'Completely Public']
	end

	# METHODS
	# ------------------------------------------------------------
	# Creator?
	# - reader is the creator
	def creator?(user)
		# when pennames and authors
	end

	# Uploader?
	# - reader is the creator
	def uploader?(user)
		self.uploader == user
	end

	def destroyable?(user)
		uploader?(user)
	end

	# Editable?
	# - asks if character can be edited
	def editable?(editor)
		@reader = editor
		@level  = self.editor_level
		uploader?(@reader) || for_public? || invited_editor?(@reader) || for_user?
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

	# JustCreated? - self explanatory
	def just_created?
		self.updated_at == self.created_at
	end

	# Unblocked?
	# - viewer is not banned from viewing
	def unblocked_access?(reader)
		!self.uploader.blocking?(reader) && !self.uploader.blocked_by?(reader)
	end

	# Viewable?
	# - asks if character is publically viewable or owned by 
	#   current user
	def viewable?(reader)
		@reader = reader
		@level  = self.publicity_level

		uploader?(@reader) || for_public? || invited_viewer?(@reader) || for_user?
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
		unblocked_access?(@reader) && (semi_public? || for_friendly? || for_following?)
	end
	
	# ForFriendlyViewer
	# - allows viewing if reader is a friend
	def for_friendly?
		@level >= Editable::FRIENDS_ONLY && @level <= Editable::FRIENDS_N_FOLLOWERS && self.uploader.friend?(@reader)
	end

	# ForFollowingViewer
	# - allows viewing if reader is a follower
	def for_following?
		@level == Editable::FRIENDS_N_FOLLOWERS && self.uploader.follower?(@reader)
	end

	# ForViewingUser
	# - allows viewing if reader is a user of the site
	def for_user?
		!@reader.nil? && (@level == Editable::MEMBERS_ONLY || check_restrictions)
	end

	# SemiPublic?
	# - check if can be viewed
	def semi_public?
		@level == Editable::EXCEPT_BLOCKED
	end

end
