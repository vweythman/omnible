function sort_description(selector, list) {
	facet = $(selector).find(":selected").text();
	t_id = $(selector).attr('id');
	t_id = t_id.split('_facet');

	d_id = t_id[0] + '_identity_id';
	if ( !$( "#" + d_id ).length ) {
		d_id = t_id[0] + '_recip_id';
	}

	options = $(list).filter('optgroup[label="' + facet + '"]').html();

	$("#" + d_id).parent().hide();
	$("#" + d_id).html(options);
	$("#" + d_id).parent().show();
}

$(document).ready(function(){

	// SETUP TOGGLE
	$(".show-toggle").click(function(){
		var id =  $(this).attr('id');
		id = id.split('_');

		$("#show_"+id[1]).hide();
		$("#form_"+id[1]).show();
	});

	$(".hide-toggle").click(function(){
		var id =  $(this).attr('id');
		id = id.split('_');

		$("#show_"+id[1]).css('display', 'block');
		$("#form_"+id[1]).hide();
	});

	$(".dismissal").click(function(){
		$(this).parent().hide();
	});

	// CREATE IDENTITY SELECTION BY FACET
	terms = $("#character_descriptions_attributes_0_identity_id").html();

	$( ".identities" ).delegate( ".selector", 'change', function() {
		sort_description(this, terms);
	});

	$(".identities .selector").on('setupDescribe', function() {
		terms = $(this).closest('fieldset').find('.selection').html();
		sort_description(this, terms);
	});

	$(".identities .selector").trigger('setupDescribe');
	
	$( ".identities" ).on('cocoon:after-insert', function(e, inserted_item) {
		inserted_item.find('.selector').trigger('change');
	});

	// BUILD TAG LIST
	$('.taggables').selectize({
		delimiter: ';',
		persist: false,
		create: function(input) {
			return {
				value: input,
				text: input
			}
		}
	});

	// WRITEABLE SELECTIONS
	$('.selectables').selectize({
		create: true,
		sortField: 'text'
	});
	$( ".nested-fieldset" ).on('cocoon:after-insert', function(e, inserted_item) {
		inserted_item.find('.selectables').selectize({
			create: true,
			sortField: 'text'
		});
	});

});

