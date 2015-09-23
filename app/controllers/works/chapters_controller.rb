class Works::ChaptersController < ApplicationController
	
	# FILTERS
	# ------------------------------------------------------------
	before_action :find_viewable_story, except: [:edit, :update]
	before_action :find_viewable_chapter, only: [:edit, :update]

	# MODULES
	# ------------------------------------------------------------
	include ContentCollections

	# PUBLIC METHODS
	# ------------------------------------------------------------
	# GET
	# ............................................................
	def index
		@chapters = @story.chapters.decorate
		@story    = @story.decorate
	end

	def show
		@chapter = Chapter.find(params[:id]).decorate
		@story   = @story.decorate
		find_chapter_comments
	end

	def new
		@chapter = @story.new_chapter.decorate
	end

	def edit
		@chapter = @chapter.decorate
	end

	# POST
	# ............................................................
	def create
		@chapter = Chapter.new(chapter_params)

		if @chapter.save
			redirect_to [@story, @chapter]
		else
			render action: 'new'
		end
	end

	# PATCH/PUT
	# ............................................................
	def update
		if @chapter.update(chapter_params)
			redirect_to [@story, @chapter]
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

	# ensures that a viewer can view
	def find_viewable_story
		@story = Story.find(params[:story_id]).decorate

		unless @story.viewable? current_user
			render 'works/restrict'
		end
	end

	def find_viewable_chapter
		@chapter = Chapter.find(params[:id])
		@story   = @chapter.story
		unless @story.viewable? current_user
			render 'works/restrict'
		end
	end

	# define strong parameters
	def chapter_params
		params.require(:chapter).permit(:title, :story_id, :about, :position, :content, :afterward)
	end
end
