class StaticPagesController < ApplicationController
  def home
  end

  def help
  end

  def about
  end

  def tags
  	@concepts   = Concept.order('name').all
  	@identities = Identity.order('name').all
    @relators   = Relator.order('left_name').all
  end
end
