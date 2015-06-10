topic
	creator, poly
	title
	allow_response

	== 
	has_one work
	has_many comments
	has_many commenters, through


discussion
	work 
	topic 

comments
	topic
	commenter, poly
	content
	depth
	allow_response


