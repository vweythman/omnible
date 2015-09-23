# Curated Methods
# ================================================================================

module CuratedCharacters

  def index
    find_characters

    @characters = CharactersCurationDecorator.decorate(@characters)
    @characters.set_parent @parent.decorate

    render 'subjects/characters/index'
  end

  def find_characters
    @characters = @parent.characters.viewable_for(current_user).order('name').decorate
  end

end