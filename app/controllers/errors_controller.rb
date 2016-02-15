class ErrorsController < ApplicationController

	def e403
		render '403'
	end

	def e404
		render '404'
	end

	def e406
		render '406'
	end

	def e422
		render '422'
	end

	def e500
		render '500'
	end

end
