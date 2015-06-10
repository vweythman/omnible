class Works::ChaptersController < ApplicationController
	
	# PUBLIC METHODS
	# ------------------------------------------------------------
	# GET
	# ............................................................
	def index
		@work     = Work.find(params[:work_id])
		@chapters = @work.chapters
		work_elements
	end

	def show
		find_chapter
		work_elements
	end

	def new
		@work    = Work.find(params[:work_id])
		@chapter = Chapter.new
		@chapter.work = @work
	end

	def edit
		find_chapter
	end

	# POST
	# ............................................................
	def create
		@work    = Work.find(params[:work_id])
		@chapter = Chapter.new(chapter_params)

		if @chapter.save
			@work.updated_at = @chapter.updated_at
			@work.save
			redirect_to [@work, @chapter]
		else
			render action: 'new'
		end
	end

	# PATCH/PUT
	# ............................................................
	def update
		find_chapter

		if @chapter.update(chapter_params)
			@work.updated_at = @chapter.updated_at
			@work.save
			redirect_to [@chapter.work, @chapter]
		else
			render action: 'edit'
		end
	end

	# DELETE
	# ............................................................
	def destroy
	end

	# PRIVATE METHODS
	# ------------------------------------------------------------
	private

	# find by id
	def find_chapter
		@chapter = Chapter.find(params[:id])
		@work    = @chapter.work
	end

	def work_elements
		@user      = @work.user
		@taggables = WorkTag.organized_all(@work.work_tags.includes(:tag))
		@mains     = @work.main_characters
		@sides     = @work.side_characters
		@mentions  = @work.mentioned_characters
	end

	# define strong parameters
	def chapter_params
		params.require(:chapter).permit(:title, :work_id, :about, :position, :content, :afterward)
	end
end
