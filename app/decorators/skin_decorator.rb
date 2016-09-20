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
	def example_area
		h.content_tag :div, id: "style-example", class: "previewer example" do
			""
		end
	end

	def heading_with_status
		"#{self.heading} + [#{self.status_type}]"
	end

	def pretty_print_area
		h.content_tag :pre, id: "style-skin", class: "previewer code css" do
			""
		end
	end

	def status_type
		@status_type ||= self.status == "Private" ? "Private Use Only" : "Public Use"
	end

	def klass
		:stylesheet_skin
	end

	def nature
		"Stylesheet"
	end

	def icon_choice
		'magic-wand'
	end

end
