module CreativeContent
	module Composition

		# GET
		# ============================================================
		def heading_with_count
			(heading + " " + length_span).html_safe
		end

		def heading_with_icon
			(icon + " " + heading).html_safe
		end

		# SET
		# ============================================================
		def length_status
			@length_status ||= h.number_with_delimiter(self.word_count, :delimiter => ",") + " Words"
		end

		def status_label
			@status_label ||= status.titleize
		end

		def title_for_creation
			@meta_title ||= "Create #{klass}".titleize
		end

		def title_for_editing
			@meta_title ||= heading + " (Editing)"
		end

		# RENDER
		# ============================================================
		def choose_creator_category
			if multiple_creator_categories?
				h.selection_field_cell "[#{self.klass}][uploadership][category]", self.creatorship_options, "Creator Category"
			else
				@category = self.creator_categories.first
				h.capture do
					h.concat(agentive_line)
					h.concat(h.hidden_field_tag("[#{self.klass}][uploadership][category]", @category.id))
				end
			end
		end

		def agentive_line
			h.content_tag :p do @category.agentive.titleize end
		end

		def creating_as(creator)
			h.content_tag :p do h.link_to(creator.name, creator).html_safe end
		end

		def length_span
			h.content_tag :span, class: "word-count" do
				length_status
			end
		end
		
		def length_data
			h.content_tag :td, :data => {:label => "Word Count"} do
				length_status
			end
		end

	end
end