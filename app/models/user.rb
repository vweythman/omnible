# User
# ================================================================================
# [description]
#
# ================================================================================

class User < ActiveRecord::Base

	# VALIDATIONS
	# ============================================================
	validates :name, presence: true
	validates :email, presence: true

	# MODULES
	# ============================================================
	include Socialable
	include Documentable
	include WithWorkCuration

	# Include default devise modules. Others available are:
	# :confirmable, :lockable, :timeoutable and :omniauthable
	devise :database_authenticatable, :registerable,
	:recoverable, :rememberable, :trackable, :validatable

	# CALLBACKS
	# ============================================================
	after_create :default_pen

	# ASSOCIATIONS
	# ============================================================
	# - Joins
	# ------------------------------------------------------------
	# :: self
	has_many :pseudonymings, dependent: :destroy
	has_many :work_opinions, dependent: :destroy

	has_many :pen_namings, ->{ Pseudonyming.pen_namings }, class_name: "Pseudonyming"
	has_many :roleplays,   ->{ Pseudonyming.roleplays },   class_name: "Pseudonyming"

	# :: invitations
	has_many :edit_invites, dependent: :destroy
	has_many :view_invites, dependent: :destroy

	# - Has
	# ------------------------------------------------------------
	# :: self
	has_one  :admin_powers,        class_name: "Admin"
	has_many :all_pens,            through: :pseudonymings, source: :character
	has_many :pen_names,           through: :pen_namings,   source: :character
	has_many :roleplay_characters, through: :roleplays,     source: :character
	has_many :skins,               foreign_key: "uploader_id"

	# :: uploads
	has_many :works,           foreign_key: "uploader_id"
	has_many :places,          foreign_key: "uploader_id", class_name: "Place"
	has_many :uploaded_items,  foreign_key: "uploader_id", class_name: "Item"
	has_many :uploaded_events, foreign_key: "uploader_id", class_name: "Event"

	has_many :onsite_works, ->{ Work.onsite },            foreign_key: "uploader_id", class_name: "Work"
	has_many :characters,   ->{ Character.not_pen_name }, foreign_key: "uploader_id", class_name: "Character"

	has_many :editables, through: :edit_invites
	has_many :viewables, through: :view_invites

	# :: tracked
	has_many :trackings
	has_many :tracked_works, through: :trackings, source: :tracked, source_type: "Work"

	# DELEGATED METHODS
	# ============================================================
	delegate :permission_level, to: :admin_powers

	# PUBLIC METHODS
	# ============================================================
	# QUESTIONS
	# ------------------------------------------------------------
	def admin?
		admin_powers.present? 
	end

	def manager?
		admin? && permission_level <= Admin::MANAGER
	end

	def site_owner?
		admin? && permission_level == Admin::OWNER
	end

	def staffer?
		admin? && permission_level <= Admin::STAFF
	end

	# GETTERS
	# ------------------------------------------------------------
	def all_uploads
		self.works.onsite + self.skins + self.roleplay_characters
	end

	def trackables
		tracked_works
	end

	# ACTIONS
	# ------------------------------------------------------------
	# Characterize - turn user into a character
	def characterize(pen_name)
		Character.create(
			name:            pen_name,
			uploader_id:     self.id,
			allow_play:      false,
			allow_clones:    false,
			allow_as_clone:  false,
			is_fictional:    false,
			editor_level:    Editable::PRIVATE,
			publicity_level: Editable::PRIVATE
		)
	end

	# Pseudonymize - create pen name
	def pseudonymize(name = self.name, is_prime = true)
		User.transaction do
			nom_de_plume = characterize(name)

			Pseudonyming.create(
				user_id:      self.id,
				character_id: nom_de_plume.id, 
				type:         "PenNaming", 
				is_primary:   is_prime
			)
		end
	end

	# Track
	# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	def track(model)
		Tracking.by_selectables(self, model).first_or_create
	end

	def untrack(model)
		Tracking.by_selectables(self, model).first.destroy
	end

	# QUESTIONS
	# ------------------------------------------------------------
	def tracking? model
		case model.class.base_class.to_s
		when "Work"
			self.tracked_works.include? model
		else
			false
		end
	end

	# PRIVATE METHODS
	# ============================================================
	private

	def default_pen
		pseudonymize(self.name, true)
	end

end
