module Nestable

	# PUBLIC METHODS
	# ------------------------------------------------------------
	# -- Headings & Toggle
	# ............................................................
	def legend
		h.content_tag :legend do "#{self.heading} #{h.hide_link(self.klass)}".html_safe end
	end

	def show_heading
		heading
	end
	
	def show
		h.show_link show_heading, klass
	end

	# -- Form
	# ............................................................
	def fields(f, nlocals = {})
		index = 0
		f.fields_for self.klass do |builder|
			
			nlocals[:f]           = builder
			nlocals[:selector_id] = index

			index = index + 1
			h.concat h.render :partial => self.partial, :locals => nlocals
		end
	end

	# -- Tag
	# ............................................................
	def formid
		"form_#{klass}"
	end

	def nest_class
		"nested #{klass}"
	end

	# -- Provided
	# ............................................................
	def heading
	end

	def klass
	end

	def partial
	end

end
