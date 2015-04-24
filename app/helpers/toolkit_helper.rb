module ToolkitHelper
	def index_toolkit(name, path_to)
		content_tag :nav, class: 'toolkit' do
			link_to "Create #{name}".titleize, path_to
		end
	end

	def work_toolkit(work)
		content_tag :nav, class: 'toolkit' do
			concat link_to 'Edit', edit_polymorphic_path(work)
			concat link_to 'Delete', work, method: :delete, data: { confirm: "Are you sure you want to delete #{work.heading}?" }
			work.content_distribution.each do |name, length|
				concat link_to "+ #{name}".singularize.titleize, new_polymorphic_path([work, "#{name}".singularize])
			end
		end
	end

	def model_toolkit(model)
		content_tag :nav, class: 'toolkit' do
			concat link_to 'Edit', edit_polymorphic_path(model)
			concat link_to 'Delete', model, method: :delete, data: { confirm: "Are you sure you want to delete #{model.heading}?" }
		end
	end

	def build_toolkit(parent, type)
		content_tag :nav, class: 'toolkit' do
			concat link_to "+ #{type}", new_polymorphic_path([parent, "#{type}".downcase ])
		end
	end

	def response_toolkit(challenge, work)
		content_tag :nav, class: 'toolkit' do
			'+ Response'
		end
	end
end