window.PollAdminView = Backbone.View.extend({ //model poll
  tagName: "div",
  className: "poll-container",
  initialize: function(){
    this.model.bind('change',this.render,this);
  },
  render: function(){
    var poll = this.model;
    var itemCollection = new ItemCollection();
    _.each(poll.get('items'),function(e){
      console.log(e);
      var item = new Item(e);
      itemCollection.push(item);
    });
    var itemCollectionView = new ItemCollectionView({model:itemCollection});
    var $text = $('<h3></h3>');
    var $title = $('<a></a>')
        .attr('href','/polls/' + poll.get('id').toString())
        .html(poll.get('title'));
    var $date = $("<i></i>").html(poll.get('date'));
    $text.append($title).append($date);
    this.$el
        .append($text)
        .append(itemCollectionView.render());
    return this.el;
  }
})

function renderPollsAdmin(url){
  $.get(url,function(data){
    var polls = data.polls;
    //console.log(polls);
    _.each(polls,function(p){
      var poll = new Poll(p);
      var pollView = new PollAdminView({model:poll});
      $('#page').append(pollView.render());
    });
  });
}




