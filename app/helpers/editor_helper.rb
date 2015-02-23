module EditorHelper

	# EDITOR FUNCTIONS
	def manage_index(name, path_to)
		content_tag :nav, class: 'maker' do
			link_to "Create #{name}".titleize, path_to
		end
	end

	def manage_nested_item(parent, item)
		content_tag :nav do 
			concat manage_item(parent)
			concat manage_item(item)
		end
	end

	def manage_item(item)
		content_tag :nav, class: 'editor' do
			# heading
			concat nav_heading(item.class.name)
			# update
			concat link_to 'Edit', edit_polymorphic_path(item)
			# delete
			concat link_to 'Delete', item, method: :delete, data: { confirm: "Are you sure you want to delete #{item.main_title}?" }
		end
	end

	def nav_heading(name)
		content_tag :span, class: 'control' do
			"Manage #{name}".titleize
		end
	end

	def mange_work(work)
		content_tag :nav do
			# heading
			concat nav_heading(work.class.name)
			# update
			concat link_to 'Edit', edit_polymorphic_path(work)
			# delete
			concat link_to 'Delete', work, method: :delete, data: { confirm: "Are you sure you want to delete #{work.main_title}?" }
			# heading
			concat nav_heading('Parts')
			# create
			work.content_distribution.each do |name, length|
				concat link_to "Add #{name}".singularize.titleize, new_polymorphic_path([work, "#{name}".singularize])
			end
		end
	end
end