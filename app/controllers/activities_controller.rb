class ActivitiesController < ApplicationController

	# PUBLIC METHODS
	# ------------------------------------------------------------
	# GET
	# ............................................................
	def index
		@activities = Activity.all
	end

	def show
		find_activity
	end

	def new
		@activity = Activity.new
	end

	def edit
		find_activity
	end

	# POST
	# ............................................................
	def create
		@activity = Activity.new(activity_params)

		if @activity.save
			redirect_to(:action => 'index')
		else
			render action: 'new'
		end	
	end

	# PATCH/PUT
	# ............................................................
	def update
		find_activity

		if @activity.update(activity_params)
		  redirect_to(:action => 'index')
		else
		 render action: 'edit'
		end
	end

	# DELETE
	# ............................................................
	def destroy
		find_activity
		@activity.destroy
		redirect_to(:action => 'index')
	end

	# PRIVATE METHODS
	# ------------------------------------------------------------
	private

	# find by id
	def find_activity
		@activity = Activity.friendly.find(params[:id])
	end
	
	# define strong parameters
	def activity_params
		params.require(:activity).permit(:name)
	end
end
