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

	# CALLBACKS
	# ------------------------------------------------------------
	after_create :default_pen

	# ASSOCIATIONS
	# ------------------------------------------------------------
	# - Joins
	# :: self
	has_many :pseudonymings, dependent: :destroy
	has_many :pen_namings, ->{ Pseudonyming.pen_namings }, class_name: "Pseudonyming"
	has_many :roleplays,   ->{ Pseudonyming.roleplays },   class_name: "Pseudonyming"

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
	# :: self
	has_many :pen_names,           through: :pen_namings, source: :character
	has_many :roleplay_characters, through: :roleplays,   source: :character

	# :: relationships
	has_many :frienders,      through: :given_friendships
	has_many :friends,        through: :friendships,        source: :friendee
	has_many :mutual_friends, through: :mutual_friendships, source: :friendee

	has_many :following, through: :follows, source: :followed
	has_many :followers, through: :followings

	# :: anti-relationships
	has_many :blocked_users, through: :blocks, source: :blocked
	has_many :blockers,      through: :given_blocks

	# :: uploads
	has_many :uploaded_works,      foreign_key: "uploader_id", class_name: "Work"
	has_many :uploaded_characters, foreign_key: "uploader_id", class_name: "Character"
	has_many :uploaded_places,     foreign_key: "uploader_id", class_name: "Place"
	has_many :uploaded_items,      foreign_key: "uploader_id", class_name: "Item"
	has_many :uploaded_events,     foreign_key: "uploader_id", class_name: "Event"

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

	# Defriend - removes friendship status
	def defriend(user)
	end

	# Pseudonymize - create pen name
	def pseudonymize(name = self.name, is_prime = true)
		User.transaction do
			nom_de_plume = characterize(name)
			Pseudonyming.create(user_id: self.id, character_id: nom_de_plume.id, type: "PenNaming", is_primary: is_prime)
		end
	end

	# Characterize - turn user into a character
	def characterize(pen_name)
		character = Character.new
		character.name            = pen_name
		character.uploader_id     = self.id
		character.allow_play      = false
		character.allow_clones    = false
		character.allow_as_clone  = false
		character.is_fictional    = false
		character.editor_level    = Editable::PRIVATE
		character.publicity_level = Editable::PRIVATE
		character.save
		return character
	end

	# PRIVATE METHODS
	# ------------------------------------------------------------
	private

	def default_pen
		pseudonymize(self.name, true)
	end

end
