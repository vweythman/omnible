Rules for Method Comments
================================================================================
Method names must be 25 characters or less. Shorter is generally better. Method
names that are obscure and not explanatory should not be used.

Table of Contents
--------------------------------------------------------------------------------
1. Model Methods
2. Controller Methods
3. Helper Methods
4. Library Methods

Model Methods
--------------------------------------------------------------------------------
Record the __name in CamelCase__ and then provide a __sentence of description__ 
below it. There should also be a table of methods in the description of the 
model. See *Rules for Model Comments* for more details. Group models by type of 
output and then alphabetically within that group. If there are more than __ten__
methods in the model, record the type of output as a header. If there are more
than ten methods within each group, there is a problem.

### Example
	# LIST
	# ............................................................
	# OrderedChapters
	# - collects the chapters of the book by their position
	# def ordered_chapters
		# internals of method
	# end

Controller Methods
--------------------------------------------------------------------------------
There are two types of controller methods: Public and Private. Public methods 
are grouped by their HTML Verb. Patch and Put are grouped together. Private 
methods have a description of what they do.

### Example
	# PUBLIC METHODS
	# ------------------------------------------------------------
	# GET
	# ............................................................
	def new
		# internals of method
	end

	# POST
	# ............................................................
	def create
		# internals of method
	end

	# PRIVATE METHODS
	# ------------------------------------------------------------
	private

	# strong params for post
	def post_params
		# internals of method
	end


Helper Methods
--------------------------------------------------------------------------------
Describe the output.

### Example
	# OUTPUTS the full page title
	def full_title
		# internals of method
	end

Library Methods
--------------------------------------------------------------------------------
Organize by output type and always provide output heading.

1. Words
	- Strings
	- Char
2. Questions
	- boolean
	- true or false
3. Lists
	- collections
	- hashes
	- arrays
4. Numerics
	- integers
	- floats
5. Things
	- objects

### Example 
	# QUESTIONS
	# ------------------------------------------------------------
	# Editable?
	# - asks if user is allowed to edit
	def editable?(user)
		# internals of method
	end
