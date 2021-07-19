import consumer from "./consumer"

consumer.subscriptions.create("CommentsChannel", {
  connected() {
    this.perform('start_st_comments', { question_id: gon.question_id } )
    // Called when the subscription is ready for use on the server
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    var data_j = JSON.parse(data)

    if (data_j.commentable_type == 'Question'){
      $('#question-' + data_j.commentable_id + ' .comments-question').append(data_j.body);
    } else if (data_j.commentable_type == 'Answer') {
      $('#answer-' + data_j.commentable_id + ' .comments-answer').append(data_j.body);
    }

    // Called when there's incoming data on the websocket for this channel
  }
});
