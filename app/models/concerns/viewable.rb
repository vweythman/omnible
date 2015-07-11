module Viewable
	PERSONAL              = 0
	INVITED               = 1
	FRIENDS               = 2
	PLUS_FOLLOWERS        = 3
	EXCEPT_BLOCKED        = 4
	EVERYONE              = 5

	# 
	def personal?
		self.publicity_level == Viewable::PERSONAL
	end

	# ForFriends?
	# - only creators and friends can view
	def for_friends?
		self.publicity_level == Viewable::FRIENDS
	end

	# ForFollowers
	# add followers to list of allowed viewers
	def and_followers?
		self.publicity_level == Viewable::PLUS_FOLLOWERS
	end

	# ForUnblocked
	# - everyone can view except for people that have been blocked
	def for_unblocked?
		self.publicity_level == Viewable::EXCEPT_BLOCKED
	end

	# IsPublic?
	# - at highest publicity level
	def is_public?
		self.publicity_level == Viewable::Everyone
	end

	#
	def creator?(reader)
		self.uploader == reader
	end

	def in_followers?(reader)
		and_followers? && self.uploader.follower?(reader)
	end

	def in_friends?(reader)
		 for_friends? && self.uploader.friend?(reader)
	end

	def not_in_blocked?(reader)
		for_unblocked? && true # check blocked list
	end

	# Viewable?
	# - asks if character is publically viewable or owned by 
	#   current user
	def viewable?(reader)
		creator?(reader) || is_public? || in_friends?(reader) || for_followers?(reader)
	end
end
