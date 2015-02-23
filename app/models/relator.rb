class Relator < ActiveRecord::Base
	has_many :relationships
	accepts_nested_attributes_for :relationships, :allow_destroy => true

	def main_title
		has_reverse? ? "#{left_name} & #{right_name}" : left_name.pluralize
	end

	def left_joiner
		"#{left_name} of"
	end

	def right_joiner
		has_reverse? ? "#{right_name} of" : left_joiner
	end
	
	def has_reverse?
		!(right_name.empty? || left_name.eql?(right_name))
	end

	def self.null_state
		NullRelator.new
	end
end

class NullRelator
	def id
		nil
	end

	def main_title
		"Relationship Types"
	end

	def part_of
		:relators
	end
end
