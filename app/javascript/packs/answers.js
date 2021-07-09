$(document).on('turbolinks:load', function(){
  $('.answers').on('click', '.edit-answer-link', function(e) {
    e.preventDefault();
    $(this).hide();
    var answerId = $(this).data('answerId');
    $('form#edit-answer-'+answerId).removeClass('hidden');
  });
  
  $('.answers').on('ajax:success', function(e){
    var voiting = e.detail[0];
    console.log(voiting.voitingable_id)
    $('.answers #answer-' + voiting.voitingable_id + ' .raiting-' + voiting.voitingable_id).html(voiting.sum_raiting);
  })
});