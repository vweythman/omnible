class Works::NotesController < ApplicationController

	# PUBLIC METHODS
	# ------------------------------------------------------------
	# GET
	# ............................................................
	def index
		@work  = Work.find(params[:work_id])
		@notes = @work.notes
	end

	def show
		find_note
		@user      = @work.user
		@taggables = WorkTag.organized_all(@work.work_tags)
		@mains     = @work.main_characters
		@sides     = @work.side_characters
		@mentions  = @work.mentioned_characters
	end

	def new
		@work = Work.find(params[:work_id])
		@note = Note.new
	end

	def edit
		find_note
	end

	# POST
	# ............................................................
	def create
		@work = Work.find(params[:work_id])
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

	# find by id
	def find_note
		@note = Note.find(params[:id])
		@work = @note.work
	end

	# define strong parameters
	def note_params
		params.require(:note).permit(:title, :work_id, :content)
	end

end
