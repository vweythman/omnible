class Categories::AgentizeController < ApplicationController

	# FILTERS
	# ============================================================
	before_action :creator_category, only: [:create, :destroy]
	before_action :work_describer,   only: [:create, :destroy]
	after_action  :update_describer, only: [:create, :destroy]

	# PUBLIC METHODS
	# ============================================================
	def create
		creator_category
		work_describer
		@describer.agentize @creator_category
		update_describer
	end

	def destroy
		creator_category
		work_describer
		@describer.deagentize @creator_category
		update_describer
	end

	# PRIVATE METHODS
	# ============================================================
	private

	def creator_category
		@creator_category = CreatorCategory.find(params[:creator_id]).decorate
	end

	def work_describer
		@describer = WorksTypeDescriber.find(params[:describer_id])
	end

	def update_describer
		@creator_category.works_type_describers.reload

		if @describer.save
			respond_to do |format|
				format.js {}
			end
		end
	end

end