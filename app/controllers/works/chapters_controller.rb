class Works::ChaptersController < ApplicationController
	
	# FILTERS
	# ------------------------------------------------------------
	before_action :find_viewable_story, except: [:edit, :update, :new, :create]
	before_action :find_editable_story,   only: [:new, :create]
	before_action :find_editable_chapter, only: [:edit, :update]

	# MODULES
	# ------------------------------------------------------------
	include ContentCollections

	# PUBLIC METHODS
	# ------------------------------------------------------------
	# GET
	# ............................................................
	def index
		@chapters = @story.chapters.ordered.decorate
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
		@chapter = @chapter.decorate

		if @chapter.save
			redirect_to [@story, @chapter]
		else
			render action: 'new'
		end
	end

	# PATCH/PUT
	# ............................................................
	def update
		@chapter = @chapter.decorate
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

	# ensures that an editor can create a new chapter of an existing story
	def find_editable_story
		@story = Story.find(params[:story_id]).decorate

		unless @story.editable? current_user
			redirect_to @story
		end
	end

	# ensures that an editor can edit an existing chapter
	def find_editable_chapter
		@chapter = Chapter.find(params[:id])
		@story   = @chapter.story
		unless @chapter.editable? current_user
			redirect_to [@story, @chapter]
		end
	end

	# define strong parameters
	def chapter_params
		params.require(:chapter).permit(:title, :story_id, :about, :position, :content, :afterward)
	end
end
