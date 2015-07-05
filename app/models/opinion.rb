class Opinion < ActiveRecord::Base

	# VALIDATIONS
	# ------------------------------------------------------------
	validates :character_id, presence: true
	validates :recip_id,     presence: true
	validates :fondness,     presence: true
	validates :respect,      presence: true

	# SCOPES
	# ------------------------------------------------------------
	scope :summarize, ->(column) { select("SUM(#{column}) as #{column}") }

	# ASSOCIATIONS
	# ------------------------------------------------------------
	belongs_to :character, :inverse_of => :prejudices
	belongs_to :recip,     class_name: "Character"

	def recip_heading
		recip.name
	end

end
