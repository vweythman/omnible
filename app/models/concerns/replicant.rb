require 'active_support/concern'

module Replicant
	extend ActiveSupport::Concern

	included do
		has_many :replications, dependent: :destroy, foreign_key: "original_id"
		has_one  :cloning,      dependent: :destroy, foreign_key: "clone_id", class_name: "Replication"
		has_one  :original,     through:   :cloning
		has_many :clones,       through:   :replications
	end

	# PUBLIC METHODS
	# ============================================================
	# ACTIONS
	# ------------------------------------------------------------
	def connect_clone(clone)
		replica = Replication.create(original_id: self, clone_id: clone.id)
	end

	def declone
		self.original = nil
	end

	# Replicate
	# - clone character and create interconnection between original and clone
	def replicate(current_user)
		unless cloneable?(current_user)
			return nil
		end

		replica  = self.amoeba_dup
		number   = self.clones.count + 1
		
		replica.name     = "#{replica.name} (Clone \##{number})"
		replica.uploader = current_user
		replica.original = self

		return replica
	end

	# QUESTIONS
	# ------------------------------------------------------------
	# CanBeAClone?
	# - asks if character can be set as a clone
	def can_be_a_clone?(visitor)
		self.allow_as_clone || self.uploader_id == visitor.id
	end

	# HasClone?
	# - character is clone of model
	def has_clone?(character)
		self.clones.include?(character)
	end

	def has_clones?
		self.clones.size > 0
	end

	# Cloneable?
	# - asks whether character can be cloned
	def cloneable?(visitor)
		self.allow_clones || self.uploader_id == visitor.id
	end

	# IsAClone?
	# - asks if character cloned from another character
	def is_a_clone?
		self.original.present?
	end

	def decloneable?(visitor)
		can_be_a_clone?(visitor)
	end

end