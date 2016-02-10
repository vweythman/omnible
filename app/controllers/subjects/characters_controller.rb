class Subjects::CharactersController < SubjectsController

	# PUBLIC METHODS
	# ============================================================
	# GET
	# ------------------------------------------------------------
	def index
		characters
	end

	def show
		character
		can_view? @character, characters_path
	end

	def new
		@character = Character.new.decorate
		associables
	end

	def edit
		character

		cannot_edit? @character do
			return
		end

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
		character

		cannot_edit? @character do
			return
		end

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
		character

		cannot_destroy? @character do
			return
		end

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
			:name,         :variations,
			:editor_level, :publicity_level,
			:allow_play,   :allow_clones,    :can_connect,

			details_attributes:     [:id, :title,    :content, :_destroy],
			possessions_attributes: [:id, :item_id,  :nature,  :_destroy],
			opinions_attributes:    [:id, :fondness, :respect, :about, :recip_id, :_destroy],
			prejudices_attributes:  [:id, :fondness, :respect, :about, :facet_id, :identity_name, :_destroy]
		)
		permitted.merge(
			:describers => params[:character][:describers], 
			:related    => params[:relator]
		)
	end

	# FIND
	# ------------------------------------------------------------
	def characters
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

end
