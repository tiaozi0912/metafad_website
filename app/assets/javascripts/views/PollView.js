window.PollView = Backbone.View.extend({ //model poll
  tagName: "div",
  className: "poll-container",
  settings: {
    title: true,
    admin: false
  },
  initialize: function(){
    this.itemCollection = this.initItemCollection();
    this.itemCollectionView = new ItemCollectionView({model:this.itemCollection,
                                                      settings:this.settings
                                                    });
    this.model.bind('change',this.render,this);
    this.model.bind('reset',this.render,this);
  },
  render: function(){
    //render title view
    var self = this;
    $.extend(self.settings,self.options.settings);
    if (this.settings.title) this.$el.append(this.titleViewRender());
    //render item collection view
    this.$el.append(this.itemCollectionView.render());
    return this.el;
  },
  initItemCollection: function(){
    var itemCollection = new ItemCollection();
    var poll = this.model;
    _.each(poll.get('items'),function(e){
      //console.log(e);
      var item = new Item(e);
      itemCollection.push(item);
    });
    return itemCollection;
  },
  titleViewRender: function(){
    var poll = this.model;
    var $text = $('<h3></h3>');
    var $title = $('<a></a>')
        .attr('href','/polls/' + poll.get('id').toString())
        .html(poll.get('title'));
    var $date = $("<i></i>").html(poll.get('date'));
    $text.append($title)
        .append($date);
    return $text;
  }
})


