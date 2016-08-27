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

	def categorized
		{
			"Sexual Content" => rating_value(sexuality),
			"Violence"       => rating_value(violence),
			"Profanity"      => rating_value(language),
		}
	end

	# PRIVATE METHODS
	# ------------------------------------------------------------
	private
	def label(type, level)
		h.content_tag :span, class: "level#{4 - level}" do
			Rating.labels[level] + " " + type
		end
	end

	def rating_value(level)
		h.content_tag :span, class: "level#{4 - level} rating" do Rating.labels[level] end
	end

end