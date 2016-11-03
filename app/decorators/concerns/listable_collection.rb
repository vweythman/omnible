module ListableCollection

	# TABLE of CONTENTS
	# ============================================================
	# 1. PUBLIC METHODS
	# ------------------------------------------------------------
	# -- A. Display Blocks
	# ----- list
	# ----- filters
	#
	# -- B. Display Text
	# ----- found_status
	#
	# -- C. Selection Methods
	# ----- heading
	# ----- page_window
	# ----- found_count
	#
	# ============================================================

	# 1. PUBLIC METHODS
	# ============================================================
	# ------------------------------------------------------------
	# 1A. DISPLAY BLOCKS
	# ------------------------------------------------------------
	def list
		h.render 'shared/lists/links', listable: self
	end

	def filters
		h.render partial: "filters"
	end

	# ------------------------------------------------------------
	# 1B. DISPLAY TEXT
	# ------------------------------------------------------------
	def found_status
		h.content_tag :p, class: "found" do found_count.to_s + " Found" end
	end

	# ------------------------------------------------------------
	# 1C. SELECTION METHODS
	# ------------------------------------------------------------
	def heading
		@heading ||= h.t("categories.#{klass}")
	end

	def klass
		@klass ||= self.class.name.underscore.split("/").last.chomp('_decorator')
	end

	def page_window
		2
	end

	def found_count
		self.count
	end
	# ============================================================

end
