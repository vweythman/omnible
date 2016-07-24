module ListableCollection

	# RENDER
	# ============================================================
	# BLOCK
	# ------------------------------------------------------------
	def list
		h.render 'shared/lists/links', listable: self
	end

	def filters
		h.render partial: "filters"
	end

	# PARAGRAPH
	# ------------------------------------------------------------
	def found_status
		h.content_tag :p, class: "found" do found_count.to_s + " Found" end
	end

	# SET
	# ============================================================
	# RESULTS DEFAULTS
	# ------------------------------------------------------------
	def page_window
		2
	end

	def found_count
		self.count
	end

end
