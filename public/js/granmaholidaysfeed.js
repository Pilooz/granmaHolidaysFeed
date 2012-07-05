// Refreshing Gps Trace
function reloadIframe() {
	$( 'div#carte iframe' ).attr( 'src', function ( i, val ) { return val; });
}

// Show all mail history
function showAllMails(b) {
 };

// Lightbox on picture link
$(function() {
	$('a.thumbnail').lightBox(); 
});

// loading all messages in ajax
$(document).ready(function(){
  $('#btn-view-all').click(function() {  
    $('#history').toggle();
     if ($('#history').css('display') == 'none') {
       $('#btn-view-all').html('<i class="icon-th-list"></i>&nbsp;Tout voir &#9658');
     }
     else {
       $('#btn-view-all').html('<i class="icon-th-list"></i>&nbsp;Masquer &#9660');
       $.ajax({
       	  url: "/loadhistory",
       	  success: function(result){
           $('#history').show(function() {
             $(this).html(result);
           });
      	 }
       });
     }  
  });
});

