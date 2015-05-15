class Relator < ActiveRecord::Base

	# MODULES
	# ------------------------------------------------------------
	include Imaginable    # member of the idea group
	include Taggable      # member of the tag group

	# ASSOCIATIONS
	# ------------------------------------------------------------
	has_many :relationships
	
	# NESTED ATTRIBUTION
	# ------------------------------------------------------------
	accepts_nested_attributes_for :relationships, :allow_destroy => true

	# METHODS
	# ------------------------------------------------------------
	# Heading
	# - defines the main means of addressing the model
	def heading
		has_reverse? ? "#{left_name} & #{right_name}" : left_name.pluralize
	end

	# LeftHeading
	# - defines the left hand relationship
	def left_heading
		"#{left_name}" unless left_name.nil?
	end

	# RightHeading
	# - defines the right hand relationship
	def right_heading
		has_reverse? ? "#{right_name}" : left_heading
	end
	
	# HasReverse?
	# - asks whether relator type has different left and right values
	def has_reverse?
		!(right_name.nil? || right_name.empty? || left_name.eql?(right_name))
	end

end
