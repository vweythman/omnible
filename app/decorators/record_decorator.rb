class RecordDecorator < WorkDecorator

	# PUBLIC METHODS
	# ------------------------------------------------------------
	# -- About
	# ............................................................
	def creation_title
		"Create Work Record"
	end

	def klass
		:record
	end

	def icon_choice
		'folder'
	end

end
