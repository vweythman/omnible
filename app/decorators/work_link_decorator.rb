class WorkLinkDecorator < WorkDecorator

	# TABLE of CONTENTS
	# ============================================================
	# 1. PUBLIC METHODS
	# ------------------------------------------------------------
	# -- A. Display Text
	# ----- link_to_host
	# ----- main_link
	# ----- uploaded_by
	#
	# -- B. Selection Methods
	# ----- creation_heading
	# ----- creation_title
	# ----- first_domain
	# ----- first_link
	# ----- nature
	#
	# ============================================================

	# 1. PUBLIC METHODS
	# ============================================================
	# ------------------------------------------------------------
	# 1A. DISPLAY TEXT
	# ------------------------------------------------------------
	def link_to_host
		hst = first_domain
		h.link_to first_domain, "http://#{first_domain}"
	end

	def main_link
		if sources.present? && h.current_user != self.uploader
			path = first_link.pathing
		else
			path = self
		end

		h.link_to self.title, path, class: "offsite-link"
	end

	def uploaded_by
		h.content_tag :p, class: 'agents' do
			("Linked by " + h.link_to(uploader.name, uploader)).html_safe
		end
	end

	# ------------------------------------------------------------
	# 1B. SELECTION METHODS
	# ------------------------------------------------------------
	def creation_heading
		title_for_creation
	end

	def creation_title
		"Create Link"
	end

	def first_domain
		first_link.host
	end

	def first_link
		@first_link ||= sources.first
	end

	def nature
		"Link"
	end
	# ============================================================

end
