class StoryLinkDecorator < WorkDecorator

	# PUBLIC METHODS
	# ------------------------------------------------------------
	# -- About
	# ............................................................
	def creation_title
		"Create Link"
	end

	def klass
		:story_link
	end

	def uploaded_by
		h.content_tag :p, class: 'agents' do
			("Linked by " + h.link_to(uploader.name, uploader)).html_safe
		end
	end

	def icon_choice
		'link'
	end

	# -- Links
	# ............................................................
	def first_link
		sources.first.reference
	end

	def main_link
		if sources.present? && h.current_user != self.uploader
			path = first_link
		else
			path = self
		end

		h.link_to self.title, path, class: "offsite-link"
	end

end
