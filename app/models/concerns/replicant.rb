require 'active_support/concern'

module Replicant
	extend ActiveSupport::Concern

	included do
		has_many :replications, dependent: :destroy, foreign_key: "original_id"
		has_one  :cloning,      dependent: :destroy, foreign_key: "clone_id", class_name: "Replication"
		has_one  :original, through: :cloning
		has_many :clones,   through: :replications
	end

	# Replicate
	# - clone character and create interconnection between original and clone
	def replicate(current_user)
		unless self.allow_clones
			return nil
		end

		replica  = self.amoeba_dup
		number   = self.clones.count + 1
		
		replica.name     = "#{replica.name} (Clone \##{number})"
		replica.uploader = current_user
		replica.original = self

		return replica
	end

	# CanBeAClone?
	# - asks if character can be set as a clone
	def can_be_a_clone?
		self.allow_as_clone == 't' || self.allow_as_clone == true
	end

	# HasClone?
	# - character is clone of model
	def has_clone?(character)
		self.clones.include?(character)
	end

	# Cloneable?
	# - asks whether character can be cloned
	def cloneable?
		self.allow_clones == true || self.allow_clones == 't'
	end

	# IsAClone?
	# - asks if character cloned from another character
	def is_a_clone?
		self.original.present?
	end
end
	