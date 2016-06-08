class Works::ChaptersController < ApplicationController

	# MODULES
	# ============================================================
	include ContentCollections

	# PUBLIC METHODS
	# ============================================================
	# GET
	# ------------------------------------------------------------
	def index
		chapters
		restricted_story
	end

	def show
		chapter
		find_chapter_comments
		restricted_story
	end

	def new
		story
		cannot_edit? @story do
			return
		end
		@chapter = Chapter.new.decorate
	end

	def edit
		chapter
		cannot_edit? @story do
			return
		end
	end

	# POST
	# ------------------------------------------------------------
	def create
		story
		cannot_edit? @story do
			return
		end

		@chapter = @story.chapters.new(chapter_params).decorate

		if @chapter.save
			redirect_to [@story, @chapter]
		else
			render action: 'new'
		end
	end

	# PATCH/PUT
	# ------------------------------------------------------------
	def update
		chapter
		cannot_edit? @story do
			return
		end

		if @chapter.update(chapter_params)
			redirect_to [@story, @chapter]
		else
			render action: 'edit'
		end
	end

	# DELETE
	# ------------------------------------------------------------
	def destroy
		chapter
		cannot_edit? @story do
			return
		end

		@chapter.destroy
		respond_to do |format|
			format.html { redirect_to @story }
			format.json { head :no_content }
		end
	end

	# PRIVATE METHODS
	# ============================================================
	private

	# CLEAN
	# ------------------------------------------------------------
	# define strong parameters
	def chapter_params
		params.require(:chapter).permit(:title, :about, :position, :content, :afterward)
	end

	# FIND
	# ------------------------------------------------------------
	def story
		@work = @story = Story.find(params[:story_id]).decorate
	end

	def chapter
		@chapter = Chapter.find(params[:id]).decorate
		@work    = @story = @chapter.story.decorate
	end

	def chapters
		story	
		@chapters = @story.chapters.ordered.decorate
	end

	# PERMIT
	# ------------------------------------------------------------
	def restricted_story
		cannot_view? @story do
			render 'works/restricted/show'
		end
	end

end