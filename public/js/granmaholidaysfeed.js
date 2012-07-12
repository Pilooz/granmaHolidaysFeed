$(document).ready(function(){
  // loading all messages in ajax
  $('#btn-view-all').click(function() {  
    $('#history').toggle();
     if ($('#history').css('display') == 'none') {
       $('#btn-view-all').html('<i class="icon-th-list"></i>&nbsp;Tout voir &#9658');
     }
     else {
       $('#btn-view-all').html('<i class="icon-th-list"></i>&nbsp;Masquer &#9660');
       $.ajax({
       	  url: "/mails",
       	  success: function(result){
           $('#history').show(function() {
             $(this).html(result);
           });
      	 }
       });
     }  
  });
});

