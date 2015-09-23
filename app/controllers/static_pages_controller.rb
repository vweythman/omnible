class StaticPagesController < ApplicationController
  def home
  	@anthologies = Anthology.recently_updated(10).decorate
  	@works       = Work.recently_updated(10).decorate
  end

  def help
  end

  def about
  end
end
