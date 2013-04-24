window.PollView = Backbone.View.extend({ //model poll
  tagName: "div",
  className: "poll-container",
  settings: {
    title: true,
    description: true,
    admin: false,
    closeBtn:false
  },
  initialize: function(){
    this.model.on('change',this.render,this);
    this.model.on('reset',this.render,this);
    //this.model.fetch();
  },
  render: function(){
    this.itemCollection = this.initItemCollection();
    this.itemCollectionView = new ItemCollectionView({model:this.itemCollection,
                                                      settings:this.settings
                                                    }); 
    //render title view
    var self = this;
    var textTemplate = _.template($('#poll-text-template').html());
    $.extend(self.settings,self.options.settings);
    this.$el.append(textTemplate(self.model.toJSON()));
    //if (this.settings.title) this.$el.append(this.titleViewRender());
    if (!this.settings.title){
      this.$el.find('.poll-title').remove();
    }
    if (!this.settings.description){
      this.$el.find('.poll-description').remove();
    }
    //render item collection view
    this.$el.append(this.itemCollectionView.render());
    return this.el;
  },
  initItemCollection: function(){
    var itemCollection = new ItemCollection();
    var poll = this.model;
    _.each(poll.get('items'),function(e){
      var item = new Item(e);
      itemCollection.push(item);
    });
    return itemCollection;
  },
  titleViewRender: function(){
    var poll = this.model;
    var $text = $("<h3 class='poll-title'></h3>");
    var $title = $('<a></a>')
        .attr('href','/polls/' + poll.get('id').toString())
        .html(poll.get('title'));
    var $date = $("<i class='date'></i>").html(poll.get('date'));
    $text.append($title)
        .append($date);
    return $text;
  }
})


