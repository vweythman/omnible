class PenNamingsDecorator < Draper::CollectionDecorator

	# PUBLIC METHODS
	# ------------------------------------------------------------
	def link_to_creation
		h.inline_creation_toolkit "Pen Name", :pen_naming
	end

	def inline_creation
		h.form_div_for_ajaxed_creation "pen-namer"
	end

	def counter
		h.content_tag :span, class: "counter" do 
			self.object.size.to_s
		end
	end

	def tableize(caption_heading = 'Pen Names')
		h.render :partial => "users/pen_namings/pen_names", :locals => { :caption_heading => caption_heading }
	end

end
