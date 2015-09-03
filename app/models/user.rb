# User
# ================================================================================
# [description]
#
# ================================================================================

class User < ActiveRecord::Base

	# VALIDATIONS
	# ------------------------------------------------------------
	validates :name, presence: true
	validates :email, presence: true

	# MODULES
	# ------------------------------------------------------------
	# Include default devise modules. Others available are:
	# :confirmable, :lockable, :timeoutable and :omniauthable
	devise :database_authenticatable, :registerable,
	:recoverable, :rememberable, :trackable, :validatable

	# ASSOCIATIONS
	# ------------------------------------------------------------
	# - Joins
	# :: invitations
	has_many :edit_invites, dependent: :destroy
	has_many :view_invites, dependent: :destroy

	# :: relationships
	has_many :friendships,       dependent: :destroy, foreign_key: "friender_id"
	has_many :given_friendships, dependent: :destroy, foreign_key: "friendee_id", class_name: "Friendship"
	has_many :mutual_friendships, ->{ Friendship.mutual }, foreign_key: "friender_id", class_name: "Friendship"

	has_many :followings, dependent: :destroy, foreign_key: "followed_id"
	has_many :follows,    dependent: :destroy, foreign_key: "follower_id", class_name: "Following"

	# :: anti-relationships
	has_many :blocks,       dependent: :destroy, foreign_key: "blocker_id"
	has_many :given_blocks, dependent: :destroy, foreign_key: "blocked_id", class_name: "Block"

	# - Has
	# :: relationships
	has_many :frienders,      through: :given_friendships
	has_many :friends,        through: :friendships,        source: :friendee
	has_many :mutual_friends, through: :mutual_friendships, source: :friendee

	has_many :following, through: :follows, source: :followed
	has_many :followers, through: :followings

	# :: anti-relationships
	has_many :blocked_users, through: :blocks, source: :blocked
	has_many :blockers,      through: :given_blocks

	# :: creations
	has_many :works,      foreign_key: "uploader_id"
	has_many :characters, foreign_key: "uploader_id"
	has_many :places,     foreign_key: "uploader_id"
	has_many :items,      foreign_key: "uploader_id"
	has_many :events,     foreign_key: "uploader_id"

	has_many :editables, through: :edit_invites
	has_many :viewables, through: :view_invites

	# PUBLIC METHODS
	# ------------------------------------------------------------
	# QUESTIONS
	# ............................................................
	# Blocking? - user is blocking another user
	def blocking?(user)
		self.blocked_users.include?(user)
	end

	# Following? - user is following another user
	def following?(user)
		self.following.include?(user)
	end

	# Follower? - user is being followed by another user
	def follower?(user)
		self.followers.include?(user)
	end

	# Friend? - user has befriended another user
	def friend?(user)
		self.friends.include?(user)
	end

	# MutualFriend? - user is the mutual friend of another user
	def mutual_friend?(user)
		self.mutual_friends.include?(user)
	end

	# ACTIONS
	# ............................................................
	# Block - blocks a user
	def block(user)
		Block.create(blocker_id: self.id, blocked_id: user.id)
	end

	# Unblock - stop blocking a user
	def unblock(user)
	
	end

	# Follow - have user follow another user
	def follow(user)
		Following.create(follower_id: self.id, followed_id: user.id)
	end

	# Unfollow - stop following another user
	def unfollow(user)
	end

	# Befriend - befriend another user
	def befriend(user)
		Friend.create(friender_id: self.id, friendee_id: user.id)
	end

	# Defrien - removes friendship status
	def defriend(user)
	end

end
