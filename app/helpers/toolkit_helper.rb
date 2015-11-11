module ToolkitHelper

	# CREATION
	# ------------------------------------------------------------
	def creation_toolkit(name, path_to)
		if user_signed_in? 
			render(:partial => "shared/toolkits/createable", :locals => { :titleized_type => name.titleize, :path_to => path_to })
		end
	end

	def inline_creation_toolkit(name, path_to)
		render(:partial => "shared/toolkits/inline_createable", :locals => { :titleized_type => name.titleize, :path_to => path_to })
	end

	# ALTERATION
	# ------------------------------------------------------------
	def alteration_toolkit(model)
		if user_signed_in? && model.editable?(current_user)
			render(:partial => "shared/toolkits/alterable", :locals => { :item => model } )
		end
	end

	def inline_alteration_toolkit(model)
		render(:partial => "shared/toolkits/inline_alterable", :locals => { :item => model } )
	end







	# INSERTIONS
	# ------------------------------------------------------------
	def insertion_link(heading, path)
		content_tag :nav, class: 'toolkit insertion' do
			link_to heading, path
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
			content_tag :nav, class: 'toolkit alteration' do
				concat link_to 'Edit', edit_polymorphic_path(model)
				concat link_to 'Delete', model, method: :delete, data: { confirm: "Are you sure you want to delete #{model.heading}?" }
			end
		end
	end

	def component_toolkit(parent, type, editable = true)
		if user_signed_in? && parent.editable?(current_user)
			content_tag :nav, class: 'toolkit insertion' do
				concat link_to "+ New #{type}", new_polymorphic_path([parent, "#{type}".downcase ])
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

	def insertable_chapter_toolkit(work, prev = nil, next_one = nil)
		if user_signed_in? && work.editable?(current_user)
			text = "+ New Chapter Here"
			
			if prev.nil?
				insertion = link_to text, work_first_chapter_path(work)
			else
				insertion = link_to text, work_chapter_insert_path(work, prev)
			end

			content_tag :nav, class: 'toolkit insertion' do
				insertion
			end
		end
	end

	def toolblock(colspan, toolkit)
		content_tag :tr, class: 'toolblock' do
			content_tag :td, colspan: colspan do
				toolkit
			end
		end
	end
end