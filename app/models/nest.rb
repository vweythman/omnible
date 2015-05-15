class Nest
	attr_reader :heading, :klass, :partial

	def initialize(heading, klass, partial)
		@heading = heading
		@klass   = klass
		@partial = partial
	end

	def form_id
		"form_#{@klass}"
	end
end