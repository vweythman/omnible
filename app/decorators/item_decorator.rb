class ItemDecorator < EditableDecorator
	delegate_all
	
	def qualities_list
		h.cslinks(self.qualities)
	end

	def description_status
		h.content_tag :p, class: 'about' do
			h.indefinite_article("#{qualities_list} #{self.generic.name}")
		end
	end

	def list_related_characters
		possessions = PossessionsDecorator.decorate(self.possessions.includes(:item, :generic))
		possessions.characters.html_safe if possessions.can_list?
	end

	def current_tags
		@tags ||= qualities.pluck(:name)
		@tags.join(";")
	end

end
