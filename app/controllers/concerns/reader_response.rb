# Reader Response
# ================================================================================

module ReaderResponse

	def work
		@work = Work.find(params[:work_id]).decorate
	end

	def opinion
		@opinion = current_user.work_opinions.by_work(@work).first
	end

	def response_format
		respond_to do |format|
			format.js { render layout: false }
		end
	end

end
