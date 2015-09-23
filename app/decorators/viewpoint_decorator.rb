class ViewpointDecorator < Draper::Decorator
	delegate_all

	def fondness_data
		data_status "Fondness", self.fondness
	end

	def respect_data
		data_status "Respect", self.respect
	end

	def details_data
		h.content_tag :td, :data => {:label => about == "" ? "" : "Details" } do
			about
		end
	end

	def data_status(data_name, lvl)
		h.content_tag :td, :data => {:label => data_name}, class: "rating level#{lvl}" do
			Judgemental.scale[lvl]
		end
	end

end
