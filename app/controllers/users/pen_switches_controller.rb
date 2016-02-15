class Users::PenSwitchesController < ApplicationController

	# PUBLIC METHODS
	# ============================================================
	def update
		@name = PenNaming.find(params[:pen_naming_id])
		@curr = current_user.pen_namings.prime_nym

		if @name.user == @curr.user
			@name.toggle_prime
			@curr.toggle_prime

			PenNaming.transaction do 
				@name.save
				@curr.save
			end

			@name = @name.decorate
			@curr = @curr.decorate
		else
			redirect_to root_url
		end
	end

end
