module DataDrivenExtension

	def datum(key)
		self.find_datum(proxy_association.owner.id, key)
	end

end
