class TagsController < ApplicationController
	def index
		@activities = Activity.all
		@concepts   = Concept.order('name').all
		@identities = Identity.organized_all
		@relators   = Relator.order('left_name').all
	end
end
