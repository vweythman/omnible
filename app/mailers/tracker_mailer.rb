class TrackerMailer < ApplicationMailer


	def notification_email(resource)
		@resource = resource

		mail(to: @resource.tracking_users.pluck(:email), subject: @resource.header + " has updated")
	end

end
