# Taggable Methods
# ================================================================================
# 
# Questions
# --------------------------------------------------------------------------------
#  method name                 | description
# --------------------------------------------------------------------------------
#  is_subject?                 | answers that model is not a subject
# ================================================================================
require 'active_support/concern'

module Taggable
	extend ActiveSupport::Concern

	# SCOPES AND ASSOCIATIONS
	# ============================================================
	included do
		scope :ordered_count, -> { order("Count(*) DESC").count }
	end

	# METHODS
	# ------------------------------------------------------------
	# IsSubject?
	# - answers that model is not a subject
	def is_subject?
		false
	end

	# Linkable
	# - grab what will be used when organizing
	def linkable
		self
	end

end
