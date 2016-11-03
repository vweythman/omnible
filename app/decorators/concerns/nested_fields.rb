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
		h.content_tag :legend do "#{self.legend_heading} #{h.hide_link(self.klass)}".html_safe end
	end

	# GET
	# ============================================================
	def show_heading
		heading
	end

	def legend_heading
		heading
	end
	
	def show
		h.show_link show_heading, klass
	end

	def owner_klass
		@owner_klass ||= object.proxy_association.owner.class.name.demodulize.downcase
	end

	# SET
	# ============================================================
	# ATTRIBUTES
	# ------------------------------------------------------------
	def formid
		"form_#{klass}"
	end

	def nest_class
		"nested-fieldset nested-#{klass}-fieldset nested-#{owner_klass}-fields"
	end

	# DEFAULTS
	# ------------------------------------------------------------
	def heading
	end

	def partial
	end

	def klass
		@klass ||= self.class.name.underscore.split("/").last.chomp('_decorator')
	end

end