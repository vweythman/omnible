class Anthology < ActiveRecord::Base
	has_many :collections
	has_many :works, :through => :collections

	accepts_nested_attributes_for :collections

	def main_title
		name
	end

	def self.null_state
		NullAnthology.new
	end
end

class NullAnthology
	def main_title
		"Anthologies"
	end

	def part_of
		:anthologies
	end

	def id
		nil
	end
end
