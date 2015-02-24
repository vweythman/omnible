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
      $("#show_"+id[1]).show();
      $("#form_"+id[1]).hide();
   });
   terms = $("#character_descriptions_attributes_0_identity_id").html();

   $( ".nested" ).delegate( ".selector", 'change', function(){
      facet = $(this).find(":selected").text();
      t_id = $(this).attr('id');
      t_id = t_id.split('_facet');
      d_id = t_id[0] + '_identity_id';
      options = $(terms).filter('optgroup[label="' + facet + '"]').html();

      $("#" + d_id).parent().hide();
      $("#" + d_id).html(options);
      $("#" + d_id).parent().show();       
   });
});
