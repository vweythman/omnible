class StaticPagesController < ApplicationController
  def home
  end

  def help
  end

  def about
  end

  def tags
    @activities = Activity.all
  	@concepts   = Concept.order('name').all
  	@identities = Identity.organized_all
    @relators   = Relator.order('left_name').all
  end
end
