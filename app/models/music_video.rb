# MusicVideo
# ================================================================================
# type of narrative work
# see Work for table variables

class MusicVideo < Work

	# ASSOCIATIONS
	# ============================================================
	has_one :embedded_link, :dependent => :destroy,  as: :referencer, class_name: "Source"

	# NESTED ATTRIBUTION
	# ============================================================
	accepts_nested_attributes_for :embedded_link

	def self.unframing(source)
		extracted = source.scan(/src="[a-zA-Z0-9:\/\._]+/).first
		extracted.slice!(0, 5)
		extracted
	end

	def duration
		[(timing / 3600).floor, ((timing % 3600) / 60).floor, (timing % 60).floor].map{|t| "%02d" % t}.join(":")
	end

	def embed_src
		embedded_link.reference
	end

	def host
		embedded_link.host
	end

end
