class CharacterDecorator < Draper::Decorator
	delegate_all

	# Define presentation-specific methods here. Helpers are accessed through
	# `helpers` (aka `h`). You can override attributes, for example:
	#
	#   def created_at
	#     helpers.content_tag :span, class: 'time' do
	#       object.created_at.strftime("%a %m/%d/%y")
	#     end
	#   end

	def heading
		name
	end

	def link_to_original
		if is_a_clone?
			h.content_tag :p, class: 'announce' do
				"Based Upon: #{h.link_to(original.name, original)}".html_safe
			end
		end
	end

	def list_aliases
		h.content_tag :p, class: 'identifiers' do
			identifiers.map { |identifier| identifier.name }.join(", ")
		end
	end

	def public_opinion_status
		@rep_amt ||= reputations.size

		"Decided by #{@rep_amt} " + "opinion".pluralize(@rep_amt)
	end

	def public_opinion
		opinion = ViewpointDecorator.decorate average_reputation
	end

	def opinion_scatter_data
		data = [
			{
				label: "Opinions",
				strokeColor: "#559933",
				data: opinions.uniques.map{|p| {x: p.fondness, y: p.respect, r: p.count} }
			},
			{
				label: "Reputations",
				strokeColor: "#4095BF",
				data: reputations.uniques.map{|p| {x: p.fondness, y: p.respect, r: p.count} }
			}
		]
	end

end
