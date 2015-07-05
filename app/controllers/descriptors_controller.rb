class DescriptorsController < ApplicationController
	def index
		@activities = Activity.all
		@tags   = Tag.order('name').all
		@identities = Identity.organized_all
		@relators   = Relator.order('left_name').all
	end
end
