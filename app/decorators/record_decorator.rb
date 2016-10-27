class RecordDecorator < WorkDecorator

	# PUBLIC METHODS
	# ------------------------------------------------------------
	# -- About
	# ............................................................
	def creation_title
		"Create Work Record"
	end

	def klass
		@klass ||= :record
	end

end
