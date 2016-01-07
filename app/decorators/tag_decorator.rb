class TagDecorator < Draper::Decorator

	# DELEGATION
	# ------------------------------------------------------------
	delegate_all

	# MODULES
	# ------------------------------------------------------------
	include NameIdentified
	include InlineEditing

	# PUBLIC METHODS
	# ------------------------------------------------------------
	# -- About
	# ............................................................
	def created_at_tag
		h.content_tag :span, class: "time" do
			h.record_time(self.created_at)
		end
	end

	def first_use_status
		h.time_label("First Use") + ": " + created_at_tag
	end

	# -- Editor
	# ............................................................
	def editor_heading
		"Edit Tag"
	end

end
