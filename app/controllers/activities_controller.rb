class ActivitiesController < ApplicationController
	def index
		@activities = Activity.all
	end

	def show
		activity_find
	end

	def new
		@activity = Activity.new
	end

	def edit
		activity_find
	end

	def create
		@activity = Activity.new(activity_params)

		if @activity.save
			redirect_to(:action => 'index')
		else
			render action: 'new'
		end	
	end

	def update
		activity_find

		if @activity.update(activity_params)
		  redirect_to(:action => 'index')
		else
		 render action: 'edit'
		end
	end

	private
	def activity_params
		params.require(:activity).permit(:name)
	end

	def activity_find
  		@activity = Activity.find(params[:id])
	end
end
