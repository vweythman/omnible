class SubjectsController < ApplicationController

	# PUBLIC METHODS
	# ============================================================
	def index
		@subjects = subjects
	end

	# PRIVATE METHODS
	# ============================================================
	private
	def subjects
		@characters = Character.not_pen_name.viewable_for(current_user)
		@items      = Item.order_by_generic
		@places     = Place.order_by_form

		Collectables::SubjectsDecorator.decorate(@characters + @items + @places)
	end

end
