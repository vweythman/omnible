module IndexHelper

	def curated_works_url_appender(parent, filter)
		url_for(parent) + '/works/?' + filter.to_query
	end

	def count_overtime_dataset(counts)
		buildset = {}
		dataset  = []
		timelength = timekeys(counts)
		timelength = timespanning(timelength.first, Time.now.strftime("%Y-%m"))

		counts.each do |key, size|
			date, type = key
			type = type.underscore.pluralize.humanize.titleize
			buildset[type] ||= Array.new(timelength.length) { 0 }
			buildset[type][timelength.index(date)] = size
		end

		buildset.each do |key, set|
			x     = SecureRandom.hex(3).to_s
			r,g,b = x.to_s.chars.each_slice(2).map(&:join).map{|n| n.to_i(16) }

			dataset << {
				"label" => key, 
				"data" => set,
				"borderColor" => "#" + x,
				"backgroundColor" => "rgba(#{r},#{g},#{b},0.4)",
				"tension" => 0.0,
				"borderJoinStyle" => "round"
			}
		end
		timelength = timelength.map{|n| x = counter_date n; x = x.split(" "); x = x.last + " " + x.first }
		[timelength, dataset]
	end

	def timespanning(st_point, ed_point)
		st_year, st_mon = st_point.split("-")
		ed_year, ed_mon = ed_point.split("-")

		st_range = (st_mon.to_i..12).map{|mon| st_year + "-%02d" % mon }
		ed_range = ( 1..ed_mon.to_i).map{|mon| ed_year + "-%02d" % mon }
		bt_range = ((st_year.to_i + 1)..(ed_year.to_i - 1)).map {|year| Array.new(12){|mon| "#{year}-" + "%02d" % (mon + 1)}}
		
		st_range + bt_range.flatten + ed_range
	end

	def timekeys(counts)
		timelength = counts.keys.map{|n| n.first}.sort
		timelength.uniq!
		timelength
	end

end
