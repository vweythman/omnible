# lib/organized_tag_groups.rb

class OrganizedTagGroups

	def initialize(tag_group)
		@tag_group = tag_group.with_indifferent_access
	end

	def group_by(key)
		found = @tag_group[key]
		found ||= []
	end

	def names_by(key)
		group_by(key).map(&:name)
	end

	def titles_by(key)
		group_by(key).map(&:title)
	end

	def all
		@tag_group
	end

end
