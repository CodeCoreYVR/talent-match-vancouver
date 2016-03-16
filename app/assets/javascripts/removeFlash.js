$(document).ready(function(){
  $('body').on('click', 'button.close', function(){
    $(this).parent().slideUp(1000);
  });
});
