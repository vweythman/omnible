module Collectables
	module Works
		class ChaptersDecorator < Draper::CollectionDecorator

			# MODULES
			# ------------------------------------------------------------
			include NestedFields

			# PUBLIC METHODS
			# ------------------------------------------------------------
			# -- Identifiers
			# ............................................................
			def heading
				"Chapters"
			end

			def meta_title
				owner_heading + " - Chapters"
			end

			def owner_heading
				object.proxy_association.owner.title
			end

			# -- Links
			# ............................................................
			def link_to_insert_first
				if story.editable?(h.current_user)
					h.content_tag :nav, class: 'toolkit insertion' do
						h.link_to "+ New First Chapter", h.first_chapter_path(story), class: "tool-link"
					end
				end
			end

			# -- Location
			# ............................................................
			def partial
				'works/chapters/nested_fields'
			end

			def story
				object.proxy_association.owner
			end

		end
	end
end
