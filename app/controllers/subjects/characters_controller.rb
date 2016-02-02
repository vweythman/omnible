class Subjects::CharactersController < SubjectsController

	# FILTERS
	# ============================================================
	# FIND
	# ------------------------------------------------------------
	before_action :character,  except: [:index, :new, :create]

	# PERMIT
	# ------------------------------------------------------------
	before_action :can_edit?, only: [:edit, :update, :delete]
	before_action :can_view?, only: [:show]

	# PUBLIC METHODS
	# ============================================================
	# GET
	# ............................................................
	def new
		@character = Character.new.decorate
		associables
	end

	def edit
		associables
	end

	# POST
	# ------------------------------------------------------------
	def create
		@character = Character.new(character_params)
		new_visitor

		if @character.save
			redirect_to @character
		else
			associables
			render 'new'
		end
	end

	# PATCH/PUT
	# ------------------------------------------------------------
	def update
		new_visitor
		if @character.update(character_params)
			redirect_to @character
		else
			associables
			render action: 'edit'
		end
	end

	# DELETE
	# ------------------------------------------------------------
	def destroy
		@character.destroy
		respond_to do |format|
			format.html { redirect_to characters_url }
			format.json { head :no_content }
		end
	end

	# PRIVATE METHODS
	# ============================================================
	private

	# CLEAN
	# ------------------------------------------------------------
	def character_params
		permitted = params.require(:character).permit(
			:name,         :variations,      :about,
			:editor_level, :publicity_level, :visitor,
			:allow_play,   :allow_clones,    :can_connect,

			details_attributes:     [:id, :title,    :content, :_destroy],
			possessions_attributes: [:id, :item_id,  :nature,  :_destroy],
			opinions_attributes:    [:id, :fondness, :respect, :about, :recip_id,   :_destroy],
			prejudices_attributes:  [:id, :fondness, :respect, :about, :facet_id, :identity_name, :_destroy]
		)
		permitted.merge(
			:describers => params[:character][:describers], 
			:related    => params[:relator]
		)
	end

	# FIND
	# ------------------------------------------------------------
	def subjects
		@subjects = @characters = Character.not_pen_name.viewable_for(current_user).order('name').decorate
	end

	def character
		@character = Character.find(params[:id]).decorate
	end

	# SET
	# ------------------------------------------------------------
	def new_visitor
		@character.uploader ||= current_user
		@character.visitor    = current_user
	end

	def associables
		@identities = IdentitiesDecorator.decorate(@character.identities)
		@items      = PossessionsDecorator.decorate(@character.items)
		@opinions   = OpinionsDecorator.decorate(@character.opinions)
		@prejudices = PrejudicesDecorator.decorate(@character.prejudices)
		@text       = @character.current_detail_text
	end

	# PERMIT
	# ------------------------------------------------------------
	def can_edit?
		unless @character.editable? current_user
			redirect_to @character
		end
	end

	def can_view?
		unless @character.viewable? current_user
			render 'restrict'
		end
	end

end
