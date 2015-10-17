class ViewpointDecorator < Draper::Decorator
	delegate_all

	def row
		th  = recip_th
		td1 = fondness_data
		td2 = respect_data
		td3 = details_data
		
		h.content_tag :tr do
			th + td1 + td2 + td3
		end
	end

	def recip_th
		h.content_tag :th, :data => {:label => "Recipient" } do
			h.link_to recip_heading, recip
		end
	end

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
