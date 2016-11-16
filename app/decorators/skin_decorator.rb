class SkinDecorator < Draper::Decorator

	# DELEGATION
	# ============================================================
	delegate_all

	# MODULES
	# ============================================================
	include CreativeContent
	include PageEditing

	# PUBLIC METHODS
	# ============================================================
	# ------------------------------------------------------------
	# DISPLAY CONTENT BLOCKS
	# ------------------------------------------------------------

	def example_area
		h.content_tag :div, id: "style-example", class: "previewer example" do
			""
		end
	end

	def metadata_block
		h.content_tag :div, class: 'metadata' do
			h.concat h.metadata("Uploaded By:" , h.link_to(uploader.name, uploader))
			h.concat h.metadata("Status:" , self.status)
			h.concat h.metadata("Updated:" , h.timestamp(updated_at))
		end
	end

	def pretty_print_area
		h.content_tag :pre, id: "style-skin", class: "previewer code css" do
			""
		end
	end

	# ------------------------------------------------------------
	# SELECT TEXT
	# ------------------------------------------------------------
	def heading_with_status
		"#{self.heading}"
	end

	def klass
		:stylesheet
	end

	def nature
		"Stylesheet"
	end

end
