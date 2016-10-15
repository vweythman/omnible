class NoteDecorator < Draper::Decorator

	# DELEGATION
	# ------------------------------------------------------------
	delegate_all

	# MODULES
	# ------------------------------------------------------------
	include CreativeContent
	include CreativeContent::Composition
	include PageEditing

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

	def manage_kit
		if self.editable?(h.current_user)
			h.content_tag :div, class: "manager-editor" do
				h.concat edit_bar
			end
		end
	end

end
