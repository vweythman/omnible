class Works::NotesController < ApplicationController

	# MODULES
	# ============================================================
	include ContentCollections

	# PUBLIC METHODS
	# ============================================================
	# GET
	# ------------------------------------------------------------
	def index
		notes
		restrict_access
	end

	def show
		note
		find_note_comments
		restrict_access
	end

	def new
		work
		cannot_edit? @work do
			return
		end
		@note = Note.new.decorate
	end

	def edit
		note
		cannot_edit? @work do
			return
		end
	end

	# POST
	# ------------------------------------------------------------
	def create
		work
		cannot_edit? @work do
			return
		end
		@note = @work.notes.new(note_params).decorate

		if @note.save
			redirect_to [@work, @note]
		else
			render action: 'new'
		end
	end

	# PATCH/PUT
	# ------------------------------------------------------------
	def update
		note
		cannot_edit? @work do
			return
		end

		if @note.update(note_params)
			redirect_to [@note.work, @note]
		else
			render action: 'edit'
		end
	end

	# DELETE
	# ------------------------------------------------------------
	def destroy
		note
		cannot_edit? @work do
			return
		end

		@note.destroy

		respond_to do |format|
			format.html { redirect_to @work }
			format.json { head :no_content }
		end
	end

	# PRIVATE METHODS
	# ============================================================
	private

	# CLEAN
	# ------------------------------------------------------------
	# define strong parameters
	def note_params
		params.require(:note).permit(:title, :work_id, :content)
	end

	def work_params
		params.slice(:work_id, :story_id, :short_story_id, :journal_id)
	end

	# FIND
	# ------------------------------------------------------------
	def note
		@note = Note.find(params[:id]).decorate
		@work = @note.work.decorate
	end

	def notes
		work	
		@notes = Collectables::Works::NotesDecorator.decorate @work.notes
	end

	def work
		@work = Work.find(work_id).decorate
	end

	def work_id
		work = work_params.first

		work.last.nil? ? params[:note][work.first] : work.last
	end

	# PERMIT
	# ------------------------------------------------------------
	def restrict_access
		cannot_view? @work do
			render 'works/restricted/show'
		end
	end

end