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
    this.$el
        .append("<h3><b>"+poll.get('title')+"</b> <i>"+poll.get('date')+"</i></h3>")
        .append(itemCollectionView.render());
    return this.el;
  }
})

function renderPollsAdmin(url){
  $.get(url,function(data){
    var polls = data.polls;
    console.log('there are '+polls.length+' polls fetched');
    //console.log(polls);
    _.each(polls,function(p){
      var poll = new Poll(p);
      var pollView = new PollAdminView({model:poll});
      $('#page').append(pollView.render());
    });
  });
}




