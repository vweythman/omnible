module Widgets
	module Recent

		# GET
		# ============================================================
		# DEFAULTS
		# ------------------------------------------------------------
		def recent_type
			:preview
		end

		# FILES
		# ------------------------------------------------------------
		def widget_partial
			"shared/widgets/recent"
		end

		def recent_partial
			"shared/lists/#{recent_type}"
		end

		# RENDER
		# ============================================================
		def recent_widget
			h.render :partial => widget_partial, :locals => { collection: self }
		end

		def recent_body
			h.render :partial => recent_partial, :locals => { listable: self }
		end

	end
end