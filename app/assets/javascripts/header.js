$(document).ready(function(){
	$('.menu li ul').hide();
	$('.menu li').hover(
		function () {
			$('ul', this).stop().slideDown(500);
		},
		function () {
			$('ul', this).stop().slideUp(500);
		}
	);
});

