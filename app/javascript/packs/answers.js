$(document).on('turbolinks:load', function(){
  $('.answers').on('click', '.edit-answer-link', function(e) {
    e.preventDefault();
    $(this).hide();
    var answerId = $(this).data('answerId');
    $('form#edit-answer-'+answerId).removeClass('hidden');
  });
  
  $('.answers').on('ajax:success', function(e){
    var voiting = e.detail[0];
    $('.answers #answer-' + voiting.voitingable_id + ' .raiting-' + voiting.voitingable_id).html(voiting.sum_raiting);
  })
    .on('ajax:error', function (e) {
      var errors = e.detail[0];

      $.each(errors, function(index, value) {
          $('.answer-errors').append('<p>' + value + '</p>');
      })

  })
});