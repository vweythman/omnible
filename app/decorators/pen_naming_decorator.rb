class PenNamingDecorator < Draper::Decorator

	# DELEGATION
	# ============================================================
	delegate_all

	# MODULES
	# ============================================================
	include CreativeContent
	include CreativeContent::Dossier
	include InlineEditing

	# PUBLIC METHODS
	# ============================================================
	def page_title
		"Dashboard (Pen Names) - #{self.heading}"
	end

	def status
		self.prime? ? default_pen : switch_link
	end

	def bylines
		@bylines ||= creatorships.joins(:category, :work).order("creator_categories.name ASC, works.title ASC")
	end

	def createable_works_list
		Collectables::WorksDecorator::ALL_TYPES.keys.map do |name|
			type = name.to_s.singularize

			[CreativeContent::ICONS[type.to_sym] || 'file-empty', name.to_s, h.polymorphic_url(type, action: :new, create_as: self.id)]
		end
	end

	def bylines_by_category
		results = {}

		bylines.each do |item|
			key = item.category.name

			if results[key].nil?
				results[key] = []
			end
			results[key] << item
		end
		results.sort
		results
	end

	# PRIVATE METHODS
	# ============================================================
	private
	def default_pen
		h.content_tag :span, class: 'default-pen' do "default".upcase end
	end

	def secondary_pen
		h.content_tag :span, class: 'secondary-pen' do "secondary" end
	end

	def switch_link
		h.link_to "Make Default", h.pen_naming_switch_path(self.id), class: "status-toggle-link", method: :put, remote: true
	end

end
