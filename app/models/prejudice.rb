# Prejudice
# ================================================================================
# subpart of characters
#
# Table Variables
# --------------------------------------------------------------------------------
#  variable        | type        | about
# --------------------------------------------------------------------------------
#  id              | integer     | unique
#  character_id    | integer     | references character
#  identity_id     | integer     | references identity
#  fondness        | integer     | scale column
#  respect         | integer     | scale column
#  about           | string      | can be null
#  created_at      | datetime    | must be earlier or equal to updated_at
#  updated_at      | datetime    | must be later or equal to created_at
# ================================================================================

class Prejudice < ActiveRecord::Base

	# VALIDATIONS
	# ------------------------------------------------------------
	validates :identity_id,  presence: true
	validates :fondness,     presence: true
	validates :respect,      presence: true

	# ASSOCIATIONS
	# ------------------------------------------------------------
	belongs_to :character, :inverse_of => :prejudices
	belongs_to :identity

	# PUBLIC METHODS
	# ------------------------------------------------------------
	# RecipHeading - gives the heading for the recipient
	def recip_heading
		identity.name.titleize.pluralize
	end

	# Recip - identity that is being judged
	def recip
		self.identity
	end

end
