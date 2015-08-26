class Works::NotesController < ApplicationController

	# PUBLIC METHODS
	# ------------------------------------------------------------
	# GET
	# ............................................................
	def index
		find_work
		@notes = @work.notes
		work_elements
	end

	def show
		find_note
		work_elements
	end

	def new
		find_work
		@note = Note.new
	end

	def edit
		find_note
	end

	# POST
	# ............................................................
	def create
		find_work
		@note = Note.new(note_params)

		if @note.save
			@work.updated_at = @note.updated_at
			@work.save
			redirect_to [@work, @note]
		else
			render action: 'new'
		end
	end

	# PATCH/PUT
	# ............................................................
	def update
		find_note

		if @note.update(note_params)
			@work.updated_at = @note.updated_at
			@work.save
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

	def find_work
		work_id = params[:work_id] || params[:story_id] || params[:short_story_id]
		@work   = Work.find(work_id)
	end

	# find by id
	def find_note
		@note = Note.find(params[:id])
		@work = @note.work
	end
	
	def work_elements
		@characters = @work.organized_characters
		@user       = @work.uploader
		@tags       = @work.tags
	end

	# define strong parameters
	def note_params
		params.require(:note).permit(:title, :work_id, :content)
	end

end
