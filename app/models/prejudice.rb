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

	# CALLBACKS
	# ------------------------------------------------------------
	before_validation :find_identity, on: :create

	# ASSOCIATIONS
	# ------------------------------------------------------------
	belongs_to :character, :inverse_of => :prejudices
	belongs_to :identity

	# ATTRIBUTES
	# ------------------------------------------------------------
	attr_accessor :facet_id, :identity_name

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

	def identity_name
		unless identity.nil?
			@identity_name ||= self.identity.name
		end
	end

	def facet_id
		unless identity.nil?
			@facet_id ||= self.identity.facet_id
		end
	end

	# PRIVATE METHODS
	# ------------------------------------------------------------
	private

	def find_identity
		self.identity = Identity.where(name: @identity_name, facet_id: @facet_id.to_i).first_or_create
	end

end
