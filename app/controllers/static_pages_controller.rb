class StaticPagesController < ApplicationController
  def home
  	@anthologies = Collectables::AnthologiesDecorator.decorate Anthology.recently_updated(5)
  	@works       = Collectables::WorksDecorator.decorate Work.onsite.recently_updated(5)
  end

  def help
  end

  def about
  end
end
