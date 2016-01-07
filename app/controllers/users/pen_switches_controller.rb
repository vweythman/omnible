class Users::PenSwitchesController < ApplicationController

	# OUTPUT FORMATS
	# ------------------------------------------------------------
	respond_to :html, :js, :json

	# PUBLIC METHODS
	# ------------------------------------------------------------
	def update
		@name = PenNaming.find(params[:pen_naming_id])
		@curr = current_user.pen_namings.prime_nym
		
		@name.toggle_prime
		@curr.toggle_prime

		PenNaming.transaction do 
			@name.save
			@curr.save
		end

		@name = @name.decorate
		@curr = @curr.decorate
	end

end
