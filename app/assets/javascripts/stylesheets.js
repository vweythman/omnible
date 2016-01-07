function csscode(selector, cssArray) {
	for (var i = 0; i < cssArray.length; i++)
	{

		v = cssArray[i];
		w = v.rules;

		$(selector).append(v.selector + " {\n");

		for (var j = 0; j < w.length; j++)
		{
			n = w[j];
			$(selector).append(n.directive + ": " + n.value + ";\n");
		}

		$(selector).append("}\n\n");
	}
}

function prettycss(selector, cssArray)
{
	for (var i = 0; i < cssArray.length; i++)
	{
		v = cssArray[i];
		w = v.rules;

		$(selector).append("<p><span class='selector'>" + v.selector + "</span><span class='brace block-start'>" + " {</span></p>");

		for (var j = 0; j < w.length; j++)
		{
			n = w[j];
			$(selector).append("<p class='property'>\t<span class='property-name'>" + n.directive + "</span><span class='punctuation separator'>:</span> <span class='property-value'>" + n.value + "</span><span class='punctuation terminator'>;</span></p>");
		}

		$(selector).append("<p class='brace block-end'>}</p>");
	}
}

function cssexample(selector, cssArray)
{
	for (var i = 0; i < cssArray.length; i++)
	{
		v   = cssArray[i];
		sel = v.selector;
		n   = sel.split(" ");

		startTag = [];
		endTag   = [];

		for(var j = 0; j < n.length; j++)
		{
			tag = n[j];

			if (tag.charAt(0) === ".")
			{
				cval = tag.substr(1);
				startTag.push("<div class='" + cval + "'>");
				endTag.unshift("</div>");
			}
			else if (tag.charAt(0) === "#")
			{
				id = tag.substr(1);
				startTag.push("<div id='" + id + "'>");
				endTag.unshift("</div>");
			}
			else {
				startTag.push("<"   + tag + ">");
				endTag.unshift("</" + tag + ">");
			}
		}

		$(selector).append(startTag.join("") + v.selector + endTag.join(""));
	}
}
