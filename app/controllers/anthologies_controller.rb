class AnthologiesController < ApplicationController

	# FILTERS
	# ============================================================
	before_action :anthology,   except: [:index, :new, :create]
	before_action :anthologies, only:   [:index]
	before_action :can_edit?,   only:   [:edit, :update, :delete]

	# PUBLIC METHODS
	# ============================================================
	# GET
	# ------------------------------------------------------------
	def show
		@works = Collectables::WorksDecorator.decorate @anthology.works
	end

	def new
		@anthology = Anthology.new.decorate
	end

	# POST
	# ------------------------------------------------------------
	def create
		@anthology = Anthology.new(anthology_params).decorate
		@anthology.uploader = current_user

		if @anthology.save
			redirect_to @anthology
		else
			render action: 'new'
		end
	end

	# PATCH/PUT
	# ............................................................
	def update
		if @anthology.update(anthology_params)
			redirect_to @anthology
		else
			render action: 'edit'
		end
	end

	# DELETE
	# ............................................................
	def destroy
		@anthology.destroy
		respond_to do |format|
			format.html { redirect_to anthologies_url }
			format.json { head :no_content }
		end
	end

	# PRIVATE METHODS
	# ------------------------------------------------------------
	private

	# Anthology :: find by id
	def anthology
		@anthology = Anthology.find(params[:id]).decorate
	end

	# AnthologyParams :: define strong parameters
	def anthology_params
		params.require(:anthology).permit(:name, :summary, collections_attributes: [:id, :work_id, :_destroy])
	end

	# Anthologies :: find all
	def anthologies
		@anthologies = Collectables::AnthologiesDecorator.decorate Anthology.alphabetic
	end

	def can_edit?
		unless @anthology.editable? current_user
			redirect_to @anthology
		end
	end

end
