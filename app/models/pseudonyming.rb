# Pseudonyming
# ================================================================================
# join table
#
# Table Variables
# --------------------------------------------------------------------------------
#  variable     | type           | about
# --------------------------------------------------------------------------------
#  id           | integer        | unique
#  user_id      | integer        | references user
#  character_id | integer        | references character
#  created_at   | datetime       | <= updated_at
#  updated_at   | datetime       | >= created_at
#  type         | string         | sti
#  is_primary   | boolean        | default: false
# ================================================================================

class Pseudonyming < ActiveRecord::Base

	# SCOPES
	# ------------------------------------------------------------
	scope :pen_namings, -> { where(:type => "PenNaming") }
	scope :roleplays,   -> { where(:type => "Roleplay") }

	# ASSOCIATIONS
	# ------------------------------------------------------------
	belongs_to :user
	belongs_to :character

	# NESTED ATTRIBUTION
	# ------------------------------------------------------------
	accepts_nested_attributes_for :character
	
	# DELEGATED METHODS
	# ------------------------------------------------------------
	delegate :name, to: :character
	delegate :editable?, to: :character

	# PUBLIC METHODS
	# ------------------------------------------------------------
	def set_uploader
		self.character.uploader_id = self.user.id
		self.character.save
	end

end
