class Works::ChaptersController < ApplicationController
	
	# PUBLIC METHODS
	# ------------------------------------------------------------
	# GET
	# ............................................................
	def index
		find_work
		@chapters = @work.chapters
		work_elements
	end

	def show
		find_chapter
		work_elements
	end

	def new
		find_work
		@chapter = @work.new_chapter
	end

	def edit
		find_chapter
	end

	# POST
	# ............................................................
	def create
		find_work
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
			redirect_to [@chapter.story, @chapter]
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

	def find_work
		@work = Work.find(params[:work_id] || params[:story_id])
	end

	def find_chapter
		@chapter = Chapter.find(params[:id])
		@work    = @chapter.story
	end

	def work_elements
		@characters = @work.organized_characters
		@user       = @work.uploader
		@tags       = @work.tags
	end

	# define strong parameters
	def chapter_params
		params.require(:chapter).permit(:title, :story_id, :about, :position, :content, :afterward)
	end
end
