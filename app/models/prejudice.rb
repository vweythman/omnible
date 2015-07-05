class Prejudice < ActiveRecord::Base

	# VALIDATIONS
	# ------------------------------------------------------------
	validates :character_id, presence: true
	validates :identity_id,  presence: true
	validates :fondness,     presence: true
	validates :respect,      presence: true

	# ASSOCIATIONS
	# ------------------------------------------------------------
	belongs_to :character, :inverse_of => :prejudices
	belongs_to :identity

	# RecipHeading
	# - gives the heading for the recipient
	def recip_heading
		identity.name.titleize.pluralize
	end

	def recip
		self.identity
	end

end
