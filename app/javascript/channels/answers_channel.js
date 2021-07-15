import consumer from "./consumer"

consumer.subscriptions.create("AnswersChannel", {
  connected() {

    // Called when the subscription is ready for use on the server
    this.perform('start_st_answers', { question_id: gon.question_id } )

  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    // console.log(data);
    var data_j = JSON.parse(data)
    // Called when there's incoming data on the websocket for this channel
    $('.answers').append(data_j.body)
  }
});
