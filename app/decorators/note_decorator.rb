class NoteDecorator < Draper::Decorator

	# DELEGATION
	# ------------------------------------------------------------
	delegate_all

	# MODULES
	# ------------------------------------------------------------
	include Agented
	include PageEditing
	include Timestamped
	include Titleizeable
	include WordCountable

	# PUBLIC METHODS
	# ------------------------------------------------------------
	# -- About
	# ............................................................
	def meta_title
		work.title + " - " + heading
	end

	# -- Creating & Editing
	# ............................................................
	def creation_title
		"Create Note"
	end

	def editor_heading
		link = h.link_to work.title, work
		h.content_tag :h1, class: 'ref' do "Edit Note of #{link}".html_safe end
	end

	# PRIVATE METHODS
	# ------------------------------------------------------------
	private

	def default_heading
		"Note"
	end

end
