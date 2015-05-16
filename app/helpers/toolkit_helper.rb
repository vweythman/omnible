module ToolkitHelper
	def index_toolkit(name, path_to)
		if user_signed_in? 
			content_tag :nav, class: 'toolkit' do
				link_to "Create #{name}".titleize, path_to
			end
		end
	end

	def work_toolkit(work)
		if user_signed_in? && work.editable?(current_user)
			content_tag :nav, class: 'toolkit' do
				concat link_to 'Edit', edit_polymorphic_path(work)
				concat link_to 'Delete', work, method: :delete, data: { confirm: "Are you sure you want to delete #{work.heading}?" }
				work.content_distribution.each do |name, length|
					concat link_to "+ #{name}".singularize.titleize, new_polymorphic_path([work, "#{name}".singularize])
				end
			end
		end
	end

	def model_toolkit(model)
		if user_signed_in?
			content_tag :nav, class: 'toolkit' do
				concat link_to 'Edit', edit_polymorphic_path(model)
				concat link_to 'Delete', model, method: :delete, data: { confirm: "Are you sure you want to delete #{model.heading}?" }
			end
		end
	end

	def component_toolkit(parent, type, editable = true)
		if user_signed_in? && parent.editable?(current_user)
			content_tag :nav, class: 'toolkit' do
				concat link_to "+ #{type}", new_polymorphic_path([parent, "#{type}".downcase ])
			end
		end
	end

	def response_toolkit(challenge, work)
		if user_signed_in? 
			content_tag :nav, class: 'toolkit' do
				'+ Response'
			end
		end
	end
end