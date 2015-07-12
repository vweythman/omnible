class Opinion < ActiveRecord::Base

	# VALIDATIONS
	# ------------------------------------------------------------
	validates :recip_id,     presence: true
	validates :fondness,     presence: true
	validates :respect,      presence: true

	# SCOPES
	# ------------------------------------------------------------
	scope :summarize, ->(column) { select("SUM(#{column}) as #{column}") }

	# ASSOCIATIONS
	# ------------------------------------------------------------
	belongs_to :character, :inverse_of => :opinions
	belongs_to :recip,     class_name: "Character"

	def recip_heading
		recip.name
	end

	def self.intersection(left_character, right_character)
	end
end
