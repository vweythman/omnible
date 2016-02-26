class Users::Uploads::CharactersController < Users::UploadsController

	# PUBLIC METHODS
	# ============================================================
	def index
		@uploads = current_user.characters
	end

	def show
		@character = Character.find(params[:id]).decorate

		unless @character.uploader? current_user
			redirect_to root_url
		end
	end

end
