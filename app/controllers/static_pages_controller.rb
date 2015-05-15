class StaticPagesController < ApplicationController
  def home
  	@anthologies = Anthology.recently_updated(10)
  	@works       = Work.recently_updated(10)
  end

  def help
  end

  def about
  end
end
