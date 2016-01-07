$(document).ready(function(){
	$('.widget .preview').hover(
		function () {
			$('.excerpt', this).stop().slideDown(200);
		},
		function () {
			$('.excerpt', this).stop().slideUp(200);
		}
	);
});

