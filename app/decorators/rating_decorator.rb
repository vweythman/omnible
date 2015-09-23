class RatingDecorator < Draper::Decorator
	delegate_all

	def full_list
		sex   = label("Sexual Content", sexuality)
		fight = label("Violence", violence)
		curse = label("Profanity", language)
		sex + " " + fight + " " + curse 
	end

	private
	def label(type, level)
		h.content_tag :span, class: "level#{4 - level}" do
			Rating.labels[level] + " " + type
		end
	end
end
