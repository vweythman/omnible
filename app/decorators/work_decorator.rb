class WorkDecorator < EditableDecorator

	delegate_all
	decorates_association :rating

	def creation_title
		"Create Work"
	end

	def editing_title
		title + " (Edit Draft)"
	end

	def editor_heading
		h.content_tag :h1 do "Edit" end
	end

	def summary
		object.summary || ""
	end

	def rated
		h.content_tag :p, class: 'ratings' do
			rating.full_list
		end
	end

	def completion_status
		state = complete? ? "Complete" : "Incomplete"
		h.content_tag :p, class: "status " + state.downcase do
			state
		end
	end
	
end
