class Works::InsertableChaptersController < Works::ChaptersController
	def first
		make_chapter
		render 'works/chapters/insertables/first'
	end

	def after
		make_chapter
		@previous = Chapter.find(params[:chapter_id])
		render 'works/chapters/insertables/after'
	end

	# POST
	# ............................................................
	def create_first
		set_chapter

		Chapter.transaction do
			@chapter.place_first
			save_chapter
		end
	end

	def create_after
		set_chapter
		@previous = Chapter.find(params[:chapter_id])

		Chapter.transaction do
			@chapter.place_after @previous
			save_chapter
		end
	end

	private
	def make_chapter
		@work     = Work.find(params[:work_id])
		@chapter  = @work.new_chapter
	end

	def save_chapter
		if @chapter.save
			@work.updated_at = @chapter.updated_at
			@work.save
			redirect_to [@work, @chapter]
		else
			render action: 'new'
		end
	end

	def set_chapter
		@work    = Work.find(params[:work_id])
		@chapter = Chapter.new(chapter_params)
	end


end
