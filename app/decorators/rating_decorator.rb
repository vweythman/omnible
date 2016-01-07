class RatingDecorator < Draper::Decorator

	# DELEGATION
	# ------------------------------------------------------------
	delegate_all

	# PUBLIC METHODS
	# ------------------------------------------------------------
	def full_list
		sex   = label("Sexual Content", sexuality)
		fight = label("Violence", violence)
		curse = label("Profanity", language)
		sex + " " + fight + " " + curse 
	end

	# PRIVATE METHODS
	# ------------------------------------------------------------
	private
	def label(type, level)
		h.content_tag :span, class: "level#{4 - level}" do
			Rating.labels[level] + " " + type
		end
	end
end
