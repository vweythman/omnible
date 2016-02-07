# Curated Methods
# ================================================================================

module CuratedCharacters

	def index
		@subjects = characters
		@subjects.set_parent @parent
	end

	def characters
		@parent     = character_parent
		@characters = @parent.characters.viewable_for(current_user).order('name')
		@characters = CharactersCurationDecorator.decorate(@characters)
	end

	def character_parent
		nil
	end

end