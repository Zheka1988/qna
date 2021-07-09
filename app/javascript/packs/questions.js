$(document).on('turbolinks:load', function(){
  $('.questions').on('click', '.edit-question-link', function(e) {
    e.preventDefault();
    $(this).hide();
    var questionId = $(this).data('questionId');
    $('form#edit-question-'+questionId).removeClass('hidden');
  });

  $('.questions').on('ajax:success', function(e){
    var voiting = e.detail[0];
    $('.questions #question-' + voiting.voitingable_id + ' .raiting-' + voiting.voitingable_id).html(voiting.sum_raiting);
  })
});