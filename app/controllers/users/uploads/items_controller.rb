class Users::Uploads::ItemsController < Users::UploadsController

	# PUBLIC METHODS
	# ============================================================
	def index
		@uploads = current_user.all_uploads.sort_by! { |x| x.heading.downcase }
	end

	def show
		@item = Item.find(params[:id]).decorate

		unless @item.uploader? current_user
			redirect_to root_url
		end
	end

end
