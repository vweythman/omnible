class Works::NotesController < ApplicationController

	# FILTERS
	# ============================================================
	before_action :work,  only:   [:index, :new, :create]
	before_action :notes, only:   [:index]
	before_action :note,  except: [:index, :new, :create]

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
		find_note_comments
	end

	def new
		@note = Note.new.decorate
	end

	# POST
	# ------------------------------------------------------------
	def create
		@note = Note.new(note_params).decorate

		if @note.save
			redirect_to [@work, @note]
		else
			render action: 'new'
		end
	end

	# PATCH/PUT
	# ------------------------------------------------------------
	def update
		if @note.update(note_params)
			redirect_to [@note.work, @note]
		else
			render action: 'edit'
		end
	end

	# DELETE
	# ------------------------------------------------------------
	def destroy
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

	def show_params
		params.slice(:work_id, :story_id, :short_story_id, :journal_id)
	end

	# FIND
	# ------------------------------------------------------------
	def work
		@work = Work.find(work_id).decorate
	end

	def note
		@note = Note.find(params[:id]).decorate
		@work = @note.work.decorate
	end

	def notes		
		@notes = @work.notes.decorate
	end

	def work_id
		work = show_params.first

		work.last.nil? ? params[:note][work.first] : work.last
	end

	# PERMIT
	# ------------------------------------------------------------
	def can_edit?
		unless @work.editable? current_user
			redirect_to [@work, @note]
		end
	end

	def can_view?
		unless @work.viewable? current_user
			render 'works/restrict'
		end
	end

end