Preferably questions should be asked only once.
------------------------------------------------------
	DON'T 
		if collection exists
			write sidebar
		if collection exists
			write main content
	DO 
		if collection exists
			write sidebar
			write main content

		or better 
			in controller 
			render collection view

View Selection belongs in the controller. 
------------------------------------------------------
If the view looks like this: 
	if accessible
		show page
	else
		show restriction notice
Then this logic should be moved to the controller
	if accessible
		render accessible view
	else
		render restricted view

Single Table Inheritance with Factory Method
	Works Table with Work Models

	Parent Model: Work

	Children Models

		VideoWork
		FictionWork
		NonfictionWork
		MusicWork


Better Documentation of Site Flow and Actions

Fandoms
	= Index
		- Organized by Media
		- Top 5 Fandom for each Media by Amount of Works
	= Show -> Redirect to 
		- List Most Recent Works
		- List Most Common Tags

	= New

	= Edit

	= Delete




