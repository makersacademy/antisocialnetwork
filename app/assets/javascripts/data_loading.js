$(document).ready(function(){
  $('#loading_modal').modal('show');
  $.post('/activities', function(data){
    $('#loading_modal').modal('hide');
  });
});