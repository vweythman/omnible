class StaticPagesController < ApplicationController
  def home
  	@anthologies = Anthology.order('lower(name)').all
  end

  def help
  end

  def about
  end
end
