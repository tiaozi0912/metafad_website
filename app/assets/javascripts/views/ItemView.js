window.ItemView = Backbone.View.extend({ //model:item
  tagName: 'div',
  className: 'item-container',
  initialize: function(){
  	this.model.bind('change',this.render,this);
  },
  render: function(){
  	var self = this;
    this.$el.append(self.image())
        .append(self.info());
    return this.el;
  },
  image: function(){
  	var model = this.model;
    $img = $("<img alt='item photo' class='item-image'>")
        .attr('src',model.get('photo_url'))
        .attr('id','item-image-' + model.get('id').toString());
    return $img;
  },
  info:function(){
  	var model = this.model;
  	var $info = $("<div class='item-info'></div>");
    $brand = $('<p></p>').html('brand:'+model.get('brand'));
    //$tags = $('<p></p>').html('tags:'+model.tags);
    $info.append($brand);
    return $info;
  }
})