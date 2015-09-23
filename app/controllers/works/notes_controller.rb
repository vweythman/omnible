class Works::NotesController < ApplicationController

	# FILTERS
	# ------------------------------------------------------------
	before_action :find_viewable_work, except: [:edit, :update]
	before_action :find_viewable_note, only:   [:edit, :update]

	# MODULES
	# ------------------------------------------------------------
	include ContentCollections

	# PUBLIC METHODS
	# ------------------------------------------------------------
	# GET
	# ............................................................
	def index
		@notes = @work.notes
		@work  = @work.decorate
	end

	def show
		@note = Note.find(params[:id]).decorate
		@work = @work.decorate
		find_note_comments
	end

	def new
		@note = Note.new.decorate
	end

	def edit
		@note = @note.decorate
	end

	# POST
	# ............................................................
	def create
		find_work
		@note = Note.new(note_params)

		if @note.save
			redirect_to [@work, @note]
		else
			render action: 'new'
		end
	end

	# PATCH/PUT
	# ............................................................
	def update
		if @note.update(note_params)
			redirect_to [@note.work, @note]
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
	def find_viewable_work
		arr     = params.slice(:story_id, :short_story_id, :journal_id)
		work_id = arr.first[1]
		@work   = Work.find(work_id).decorate

		unless @work.viewable? current_user
			render 'works/restrict'
		end
	end

	def find_viewable_note
		@note = Note.find(params[:id])
		@work = @note.work
		unless @work.viewable? current_user
			render 'works/restrict'
		end
	end

	# define strong parameters
	def note_params
		params.require(:note).permit(:title, :work_id, :content)
	end

end
