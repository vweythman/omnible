class Works::RestrictedController < WorksController

	def show
		work

		if @work.viewable? current_user
			redirect_to @work
		end
	end

end
