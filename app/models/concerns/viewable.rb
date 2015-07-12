module Viewable
	
	# VARIABLES
	# ------------------------------------------------------------
	attr_accessor :reader
	attr_accessor :level

	# CONSTANTS
	# ------------------------------------------------------------
	PRIVATE             = 0
	FRIENDS_ONLY        = 1
	FRIENDS_N_FOLLOWERS = 2
	MEMBERS_ONLY        = 3
	EXCEPT_BLOCKED      = 4
	PUBLIC              = 5

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
		@level == Viewable::PUBLIC || (@level == Viewable::EXCEPT_BLOCKED && unblocked_access?(@reader))
	end

	# CheckRestrictions
	# - checks various publicity levels
	def check_restrictions
		unblocked_access?(@reader) && (for_friendly? || for_following? || for_user?)
	end
	
	# ForFriendlyViewer
	# - allows viewing if reader is a friend
	def for_friendly?
		@level <= Viewable::FRIENDS_N_FOLLOWERS && self.uploader.friend?(@reader)
	end

	# ForFollowingViewer
	# - allows viewing if reader is a follower
	def for_following?
		@level == Viewable::FRIENDS_N_FOLLOWERS && self.uploader.follower?(@reader)
	end

	# ForViewingUser
	# - allows viewing if reader is a user of the site
	def for_user?
		@level == Viewable::MEMBERS_ONLY && !@reader.nil
	end

end
