class StaticPagesController < ApplicationController
  def home
  	@anthologies = Anthology.recently_updated(5).decorate
  	@works       = Work.local.recently_updated(5).decorate
  end

  def help
  end

  def about
  end
end
