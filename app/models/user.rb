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

	has_many :friendships,                                 dependent: :destroy, foreign_key: "friender_id"
	has_many :mutual_friendships, ->{ Friendship.mutual }, dependent: :destroy, foreign_key: "friender_id", class_name: "Friendship"
	has_many :friends,        :through => :friendships, source: :friendee
	has_many :mutual_friends, :through => :mutual_friendships, source: :friendee

	has_many :followings, dependent: :destroy, foreign_key: "followed_id"
	has_many :follows,    dependent: :destroy, foreign_key: "follower_id", class_name: "Following"
	has_many :followers, :through => :followings
	has_many :following, :through => :follows, source: :followed

	def following?(user)
		self.following.include?(user)
	end

	def follower?(user)
		self.followers.include?(user)
	end

	def friend?(user)
		self.friends.include?(user)
	end

	def mutual_friend?(user)
		self.mutual_friends.include?(user)
	end

end
