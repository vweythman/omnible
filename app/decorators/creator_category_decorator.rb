class CreatorCategoryDecorator < Draper::Decorator

	# DELEGATION
	# ------------------------------------------------------------
	delegate_all

	# MODULES
	# ------------------------------------------------------------
	include InlineEditing
	include ToggleAbility

	# PUBLIC METHODS
	# ------------------------------------------------------------
	def agentable_block(work_type)
		(self.connected? work_type) ? connection_status(work_type) :  disconnection_status(work_type)
	end

	def klass
		@klass ||= :creator_category
	end

	# PRIVATE METHODS
	# ------------------------------------------------------------
	private

	def connection_status(work_type)
		h.content_tag :td, class: "true enabler-status" do (
			(h.content_tag :span, class: "label" do "Connected" end) + 
			disable_button(h.destroy_agent_path(work_type, object), "Disconnect")
		).html_safe
		end
	end

	def disconnection_status(work_type)
		h.content_tag :td, class: "false enabler-status" do (
			(h.content_tag :span, class: "label" do "Unconnected" end) + 
			enable_button(h.create_agent_path(work_type, object), "Connect")
		).html_safe
		end
	end

end
