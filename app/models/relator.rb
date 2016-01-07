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
	include EditableCategory

	# SCOPES
	# ------------------------------------------------------------
	# - General Sorting
	scope :has_reverse,   -> { where("right_name <> ''") }
	scope :lacks_reverse, -> { where("right_name == ''") }

	# - Name Lists
	scope :left_names,  -> { pluck(:left_name) }
	scope :right_names, -> { has_reverse.pluck(:right_name) }

	# - Name Relators
	scope :unreversible_lefts,  -> { has_reverse.select(:id, :left_name)  }
	scope :unreversible_rights, -> { has_reverse.select(:id, :right_name) }

	# ASSOCIATIONS
	# ------------------------------------------------------------
	has_many :interconnections, dependent: :destroy
	
	# NESTED ATTRIBUTION
	# ------------------------------------------------------------
	accepts_nested_attributes_for :interconnections, :allow_destroy => true

	# CLASS METHODS
	# ------------------------------------------------------------
	def self.all_names
		Relator.left_names + Relator.right_names
	end

	# PUBLIC METHODS
	# ------------------------------------------------------------
	# DefaultDirection - picks the direction of the relator
	def default_direction
		if has_left?
			has_right? ? "either" : "left"
		else
			"right"
		end
	end

	# LeftHeading - defines the left hand interconnection
	def left_heading
		left_name unless left_name.nil?
	end

	# RightHeading - defines the right hand interconnection
	def right_heading
		has_reverse? ? right_name : left_heading
	end
	
	# HasReverse? - asks whether relator type has different left and right values
	def has_reverse?
		!(right_name.nil? || right_name.empty? || left_name.eql?(right_name))
	end

	def editable? user
		user.staffer?
	end

	private

	def has_left?
		attributes.has_key? ('left_name')
	end

	def has_right?
		attributes.has_key? ('right_name')
	end


end
