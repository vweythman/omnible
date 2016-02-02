# Curated Methods
# ================================================================================

module CuratedCharacters

	def index
		@subjects = characters
		@characters.set_parent @parent
	end

	def characters
		@parent     = character_parent
		@characters = @parent.characters.viewable_for(current_user).order('name')
		CharactersCurationDecorator.decorate(@characters)
	end

	def character_parent
		nil
	end

end