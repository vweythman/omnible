class SkinDecorator < Draper::Decorator

	# DELEGATION
	# ------------------------------------------------------------
	delegate_all

	# MODULES
	# ------------------------------------------------------------
	include Agented
	include Pathable

	# PUBLIC METHODS
	# ------------------------------------------------------------
	def pretty_print_area
		h.content_tag :pre, id: "style-skin", class: "previewer code css" do
			""
		end
	end

	def example_area
		h.content_tag :div, id: "style-example", class: "previewer example" do
			""
		end
	end

	def heading_with_status
		self.heading + " [" + self.status_type + "]"
	end

	def status_type
		@status_type ||= self.status == "Private" ? "Private Use Only" : "Public Use"
	end

	# PRIVATE METHODS
	# ------------------------------------------------------------
	private
	def path_links
		{
			"All Skins" => h.skins_path
		}
	end

end
