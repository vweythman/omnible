class Categories::AgentizeController < ApplicationController

	# FILTERS
	# ============================================================
	before_action :admin_restriction

	# PUBLIC METHODS
	# ============================================================
	def create
		creator_category
		work_describer

		@describer.agentize @creator_category
		reload_describer
	end

	def destroy
		creator_category
		work_describer

		@describer.deagentize @creator_category
		reload_describer
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

	def reload_describer
		@creator_category.type_describers.reload

		if @describer.save
			respond_to do |format|
				format.js {}
			end
		end
	end

end