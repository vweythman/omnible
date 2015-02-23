class Concept < ActiveRecord::Base
	has_many :conceptions
	has_many :works, :through => :conceptions

	def main_title
		name
	end
	
	def self.null_state
		NullConcept.new
	end
end

class NullConcept
	def id
		nil
	end

	def main_title
		"Concepts"
	end

	def part_of
		:concepts
	end
end

