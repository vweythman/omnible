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
});
