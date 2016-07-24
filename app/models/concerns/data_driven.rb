module DataDriven

	def find_datum(wid, key)
		self.where(key: key, work_id: wid).first_or_create
	end

end
