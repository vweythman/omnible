module HeaderHelper
	def index_header(title, path_to_new)
		nest_index_header(title, title.singularize, path_to_new)
	end

	def nest_index_header(full_title, model_name, path_to_new)
		provide(:title, sanitize(full_title.html_safe, :tags=>[]))
		content_tag :header do 
			concat "<h1>#{full_title}</h1>".html_safe
			concat manage_index(model_name, path_to_new)
		end
	end

	def curated_index_header(parent, child_model_name)
		title   = "#{@parent.main_title} / #{child_model_name}"
		heading = content_tag :h1 do title end
		
		provide(:title, title)
		content_tag :header do
			heading
		end
	end

	def creation_header(heading)
		provide(:title, "Create #{heading}")
		content_tag :h1 do
			"Create #{heading}".html_safe
		end
	end

	def edit_header(name, title)
		provide(:title, "Edit #{title}")
		content_tag :h1 do
			"Edit #{name}"
		end
	end

	def show_header(model)
		provide(:title, model.main_title)
		content_tag :header do
			concat manage_item(model)
			concat "<h1>#{model.main_title.titleize}</h1>".html_safe
			concat render(:partial => 'meta', :object => model)
		end
	end

	def work_header(work)
		provide(:title, work.main_title)
		content_tag :header do
			concat mange_work(work)
			concat write_about(work.main_title, work.summary)
			concat render('works/meta', work: work)
		end
	end
	
	def work_child_header(work, child) 
		provide(:title, child.main_title)
		content_tag :header do
			concat mange_work(work)
			concat write_about(work.main_title, work.summary)
			concat render('works/meta', work: work)
		end
	end

	def nest_show_header(main_title, p_title, p_about, p_manage, p_meta) 
		provide(:title, main_title)
		content_tag :header do
			concat p_manage
			concat write_about(p_title, p_about)
			concat p_meta
		end
	end

	def write_about(name, about)
		concat "<h1>#{name}</h1>".html_safe
		content_tag :div, class: 'about' do
			markdown about || ""
		end
	end
end
