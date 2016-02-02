module NestedFields

	# RENDER
	# ============================================================
	def fields(f, nlocals = {})
		index = 0
		f.fields_for self.klass do |builder|
			
			nlocals[:f]           = builder
			nlocals[:selector_id] = index

			index = index + 1
			h.concat h.render :partial => self.partial, :locals => nlocals
		end
	end

	def legend
		h.content_tag :legend do "#{self.heading} #{h.hide_link(self.klass)}".html_safe end
	end

	# GET
	# ============================================================
	def show_heading
		heading
	end
	
	def show
		h.show_link show_heading, klass
	end

	# SET
	# ============================================================
	# ATTRIBUTES
	# ------------------------------------------------------------
	def formid
		"form_#{klass}"
	end

	def nest_class
		"nested #{klass}"
	end

	# DEFAULTS
	# ------------------------------------------------------------
	def heading
	end

	def klass
	end

	def partial
	end

end