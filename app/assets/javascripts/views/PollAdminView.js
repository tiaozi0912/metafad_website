window.PollAdminView = Backbone.View.extend({ //model poll
  tagName: "div",
  className: "poll-container",
  settings:{
    admin:true,
    voteEnabled:false
  },
  initialize: function(){
    this.model.on('change',this.render,this);
  },
  render: function(){
    var poll = this.model;
    var itemCollection = new ItemCollection();
    _.each(poll.get('items'),function(e){
      //console.log(e);
      var item = new Item(e);
      itemCollection.push(item);
    });
    var itemCollectionView = new ItemCollectionView({model:itemCollection,
                                                    settings: this.settings
                                                    });
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
  deleteBtnListener();
  function deleteBtnListener(){
    $('body').on('click','.item-container .delete-btn',function(){
      var itemID = $(this).parents('.item-container').find('.item-image').attr('id').replace(/item-image-/,"");
      var url = '/items/' + itemID + '/delete';
      var self = this;
      $.get(url,function(){
        alert('item deleted!');
        $(self).parents('.item-container').css("opacity",0.25);
      });
    })
  }
}




