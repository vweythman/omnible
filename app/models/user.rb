# User
# ================================================================================
# [description]
#
# ================================================================================

class User < ActiveRecord::Base
	# Include default devise modules. Others available are:
	# :confirmable, :lockable, :timeoutable and :omniauthable
	devise :database_authenticatable, :registerable,
	:recoverable, :rememberable, :trackable, :validatable

	# VALIDATIONS
	# ------------------------------------------------------------
	validates :name, presence: true
	validates :email, presence: true

	# ASSOCIATIONS
	# ------------------------------------------------------------
	has_many :works
	has_many :characters, foreign_key: "uploader_id"

	has_many :friendships, dependent: :destroy, foreign_key: "friender_id"
	has_many :mutual_friendships, ->{ Friendship.mutual }, dependent: :destroy, foreign_key: "friender_id", class_name: "Friendship"
	has_many :friends,        through: :friendships, source: :friendee
	has_many :mutual_friends, through: :mutual_friendships, source: :friendee

	has_many :followings, dependent: :destroy, foreign_key: "followed_id"
	has_many :follows,    dependent: :destroy, foreign_key: "follower_id", class_name: "Following"
	has_many :followers, through: :followings
	has_many :following, through: :follows, source: :followed

	has_many :blocks, dependent: :destroy, foreign_key: "blocker_id"
	has_many :blocked_users, through: :blocks, source: :blocked

	# Blocking?
	# - user is blocking another user
	def blocking?(user)
		self.blocked_users.include?(user)
	end

	# Following?
	# - user is following another user
	def following?(user)
		self.following.include?(user)
	end

	# Follower?
	# - user is being followed by another user
	def follower?(user)
		self.followers.include?(user)
	end

	# Friend?
	# - user has befriended another user
	def friend?(user)
		self.friends.include?(user)
	end

	# MutualFriend?
	# - user is the mutual friend of another user
	def mutual_friend?(user)
		self.mutual_friends.include?(user)
	end

	# Block
	# - blocks a user
	def block(user)
	end

	# Follow
	# - have user follow another user
	def follow(user)
		Following.create(follower_id: self.id, followed_id: user.id)
	end

	# Unfollow
	# - stop following another user
	def unfollow(user)
	end

	# Befriend
	# - befriend another user
	def befriend(user)
	end

	# Defriend
	# - removes friendship status
	def defriend(user)
	end

end
