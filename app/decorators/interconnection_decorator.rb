class InterconnectionDecorator < Draper::Decorator
	delegate_all
	decorates_association :left
	decorates_association :right
	decorates_association :relator
	
	
	
end
