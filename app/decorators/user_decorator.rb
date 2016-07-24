class UserDecorator < Draper::Decorator
	
	# DELEGATION
	# ------------------------------------------------------------
	delegate_all

	# PUBLIC METHODS
	# ------------------------------------------------------------
	def uploadable_types
		[:article, :character, :item, :place, :story, :short_story]
	end

	def linkable_types
		[:story_link]
	end

end
