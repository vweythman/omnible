# Curated Methods
# ================================================================================

module CuratedCharacters

	def index
		@parent = character_parent
		cannot_view? @parent do
			redirect_to root_url
			return
		end

		@subjects = characters
		@subjects.set_parent @parent
	end

	def characters		
		@characters = @parent.characters.viewable_for(current_user).order('name')
		@characters = CharactersCurationDecorator.decorate(@characters)
	end

	def character_parent
		nil
	end

end