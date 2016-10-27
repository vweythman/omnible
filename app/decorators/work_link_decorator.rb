class WorkLinkDecorator < WorkDecorator

	# PUBLIC METHODS
	# ------------------------------------------------------------
	# -- About
	# ............................................................
	def creation_title
		"Create Link"
	end

	def klass
		@klass ||= :work_link
	end

	def uploaded_by
		h.content_tag :p, class: 'agents' do
			("Linked by " + h.link_to(uploader.name, uploader)).html_safe
		end
	end

	def nature
		"Link"
	end
	
	def creation_heading
		title_for_creation
	end

	# -- Links
	# ............................................................
	def first_link
		@first_link ||= sources.first
	end

	def main_link
		if sources.present? && h.current_user != self.uploader
			path = first_link.pathing
		else
			path = self
		end

		h.link_to self.title, path, class: "offsite-link"
	end

	def first_domain
		first_link.host
	end

	def link_to_host
		hst = first_domain
		h.link_to first_domain, "http://#{first_domain}"
	end

end
