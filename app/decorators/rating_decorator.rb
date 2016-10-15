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
			"Sexual Content" => rating_value(sexuality, "Sexual Content"),
			"Violence"       => rating_value(violence,  "Violence"),
			"Profanity"      => rating_value(language,  "Profanity"),
		}
	end

	def max_rating_value
		labels = Rating.labels
		rating_value(self.max, "Sexual Content: #{labels[sexuality]} | Violence: #{labels[violence]} | Profanity: #{labels[language]}")
	end

	# PRIVATE METHODS
	# ------------------------------------------------------------
	private
	def label(type, level)
		h.content_tag :span, class: "level#{4 - level}" do
			Rating.labels[level] + " " + type
		end
	end

	def rating_value(level, title)
		h.content_tag :span, title: title, class: "level#{4 - level} rating" do Rating.labels[level] end
	end

end