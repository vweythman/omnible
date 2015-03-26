$(document).ready(function(){
   $(".show").click(function(){
      var id =  $(this).attr('id');
      id = id.split('_');
      $("#show_"+id[1]).hide();
      $("#form_"+id[1]).show();
   });
    
   $(".hide").click(function(){
      var id =  $(this).attr('id');
      id = id.split('_'); 
      $("#show_"+id[1]).css('display', 'block');
      $("#form_"+id[1]).hide();
   });
   terms = $("#character_descriptions_attributes_0_identity_id").html();

   $( "#form_desc" ).delegate( ".selector", 'change', function(){
      facet = $(this).find(":selected").text();
      t_id = $(this).attr('id');
      t_id = t_id.split('_facet');
      d_id = t_id[0] + '_identity_id';
      options = $(terms).filter('optgroup[label="' + facet + '"]').html();

      $("#" + d_id).parent().hide();
      $("#" + d_id).html(options);
      $("#" + d_id).parent().show();       
   });

   $("#form_desc .selector").trigger('change');
   $( "#form_desc" ).on('cocoon:after-insert', function(e, inserted_item) {
      inserted_item.find('.selector').trigger('change');
   })
});
