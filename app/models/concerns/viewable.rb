module Viewable

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
		@level == PUBLIC
	end

	# CheckRestrictions
	# - checks various publicity levels
	def check_restrictions
		unblocked_access?(@reader) && (semi_public? || for_friendly? || for_following? || for_user?)
	end
	
	# ForFriendlyViewer
	# - allows viewing if reader is a friend
	def for_friendly?
		@level > Visibility::PERSONAL && @level <= Visibility::FRIENDS_N_FOLLOWERS && self.uploader.friend?(@reader)
	end

	# ForFollowingViewer
	# - allows viewing if reader is a follower
	def for_following?
		@level == Visibility::FRIENDS_N_FOLLOWERS && self.uploader.follower?(@reader)
	end

	# ForViewingUser
	# - allows viewing if reader is a user of the site
	def for_user?
		@level == Visibility::MEMBERS_ONLY && !@reader.nil
	end

	# SemiPublic?
	# - check if can be viewed
	def semi_public?
		@level == Visibility::EXCEPT_BLOCKED
	end

end
