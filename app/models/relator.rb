# Relator
# ================================================================================
# categories for interconnections
#
# Table Variables
# --------------------------------------------------------------------------------
#  variable name   | type        | about
# --------------------------------------------------------------------------------
#  id              | integer     | unique
#  left_name       | string      | length <= 250 characters
#  right_name      | string      | length <= 250 characters
#  created_at      | datetime    | <= updated_at
#  updated_at      | datetime    | >= created_at
# ================================================================================

class Relator < ActiveRecord::Base

	# MODULES
	# ------------------------------------------------------------
	include Taggable

	# ASSOCIATIONS
	# ------------------------------------------------------------
	has_many :interconnections, dependent: :destroy
	
	# NESTED ATTRIBUTION
	# ------------------------------------------------------------
	accepts_nested_attributes_for :interconnections, :allow_destroy => true

	# METHODS
	# ------------------------------------------------------------
	# Heading - defines the main means of addressing the model
	def heading
		has_reverse? ? "#{left_name} & #{right_name}" : left_name.pluralize
	end

	# LeftHeading - defines the left hand interconnection
	def left_heading
		"#{left_name}" unless left_name.nil?
	end

	# RightHeading - defines the right hand interconnection
	def right_heading
		has_reverse? ? "#{right_name}" : left_heading
	end
	
	# HasReverse? - asks whether relator type has different left and right values
	def has_reverse?
		!(right_name.nil? || right_name.empty? || left_name.eql?(right_name))
	end

end
