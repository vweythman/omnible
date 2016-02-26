require 'active_support/concern'

module Socialable
	extend ActiveSupport::Concern

	# ASSOCIATIONS
	# ============================================================
	included do
		# JOINS
		# ------------------------------------------------------------
		# :: relationships
		has_many :friendships,       dependent: :destroy, foreign_key: "friender_id"
		has_many :given_friendships, dependent: :destroy, foreign_key: "friendee_id", class_name: "Friendship"
		has_many :mutual_friendships, ->{ Friendship.mutual }, foreign_key: "friender_id", class_name: "Friendship"

		has_many :followings, dependent: :destroy, foreign_key: "followed_id"
		has_many :follows,    dependent: :destroy, foreign_key: "follower_id", class_name: "Following"

		# :: anti-relationships
		has_many :blocks,       dependent: :destroy, foreign_key: "blocker_id"
		has_many :given_blocks, dependent: :destroy, foreign_key: "blocked_id", class_name: "Block"

		# HAS
		# ------------------------------------------------------------
		# :: relationships
		has_many :frienders,      through: :given_friendships
		has_many :friends,        through: :friendships,        source: :friendee
		has_many :mutual_friends, through: :mutual_friendships, source: :friendee

		has_many :following, through: :follows, source: :followed
		has_many :followers, through: :followings

		# :: anti-relationships
		has_many :blocked_users, through: :blocks, source: :blocked
		has_many :blockers,      through: :given_blocks
	end

	# PUBLIC METHODS
	# ============================================================
	# ACTIONS
	# ------------------------------------------------------------
	# Block
	# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	def block(user)
		Block.create(blocker_id: self.id, blocked_id: user.id)
	end

	def unblock(user)
	
	end

	# Follow
	# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	def follow(user)
		Following.create(follower_id: self.id, followed_id: user.id)
	end

	def unfollow(user)
	end

	# Friend
	# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	def befriend(user)
		Friend.create(friender_id: self.id, friendee_id: user.id)
	end

	def defriend(user)
	end

	# QUESTIONS
	# ------------------------------------------------------------
	# Block
	# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	def blocking?(user)
		self.blocked_users.include? user
	end

	def blocked_by?(user)
		self.blockers.include? user
	end

	# Follow
	# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	def following?(user)
		self.following.include?(user)
	end

	def followed_by?(user)
		self.followers.include?(user)
	end

	# Friend
	# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	def friend?(user)
		self.friends.include?(user)
	end

	def mutual_friend?(user)
		self.mutual_friends.include?(user)
	end

end