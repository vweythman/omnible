class Users::Uploads::CharactersController < Users::UploadsController

	# PUBLIC METHODS
	# ============================================================
	def index
		@uploads = current_user.characters
	end

	def show
		@character = current_user.characters.find_by_id(params[:id]).decorate

		unless @character.nil?
			redirect_to root_url
		end
	end

end
