class Admin::FacetsController < ApplicationController
	def show
		@user = current_user.decorate
	end
end
