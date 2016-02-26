class Users::Uploads::ItemsController < Users::UploadsController

	# PUBLIC METHODS
	# ============================================================
	def index
		@uploads = current_user.all_uploads.sort_by! { |x| x.heading.downcase }
	end

	def show
		@upload = current_user.all_uploads.sort_by! { |x| x.heading.downcase }
	end

end
