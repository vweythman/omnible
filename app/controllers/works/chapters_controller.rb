class Works::ChaptersController < ApplicationController
	
	# FILTERS
	# ============================================================
	before_action :story,    only:   [:index, :new, :create]
	before_action :chapters, only:   [:index]
	before_action :chapter,  except: [:index, :new, :create]

	before_action :can_view?, only:   [:index, :show]
	before_action :can_edit?, except: [:index, :show]

	# MODULES
	# ============================================================
	include ContentCollections

	# PUBLIC METHODS
	# ============================================================
	# GET
	# ------------------------------------------------------------
	def show
		find_chapter_comments
	end

	def new
		@chapter = @story.new_chapter.decorate
	end

	# POST
	# ------------------------------------------------------------
	def create
		@chapter = Chapter.new(chapter_params).decorate

		if @chapter.save
			redirect_to [@story, @chapter]
		else
			render action: 'new'
		end
	end

	# PATCH/PUT
	# ------------------------------------------------------------
	def update
		@chapter = @chapter.decorate
		if @chapter.update(chapter_params)
			redirect_to [@story, @chapter]
		else
			render action: 'edit'
		end
	end

	# DELETE
	# ------------------------------------------------------------
	def destroy
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
		params.require(:chapter).permit(:title, :story_id, :about, :position, :content, :afterward)
	end

	# FIND
	# ------------------------------------------------------------
	def story
		@story = Story.find(params[:story_id]).decorate
	end

	def chapter
		@chapter = Chapter.find(params[:id]).decorate
		@story   = @chapter.story.decorate
	end

	def chapters		
		@chapters = @story.chapters.decorate
	end

	# PERMIT
	# ------------------------------------------------------------
	def can_edit?
		unless @story.editable? current_user
			redirect_to [@story, @chapter]
		end
	end

	def can_view?
		unless @story.viewable? current_user
			render 'works/restrict'
		end
	end

end