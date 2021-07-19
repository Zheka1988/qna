import consumer from "./consumer"

consumer.subscriptions.create("QuestionsChannel", {
  connected() {
    // Called when the subscription is ready for use on the server
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    var data_j = JSON.parse(data)
    // console.log(data_j)
    $('.questions').append(data_j.title)
    // $('.questions').append(data['question']);
    // $(".questions").append(JST["question"]({world: "World"}))
    // Called when there's incoming data on the websocket for this channel
  }
});
