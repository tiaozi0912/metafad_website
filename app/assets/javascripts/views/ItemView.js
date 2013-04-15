window.ItemView = Backbone.View.extend({ //model:item
  tagName: 'div',
  className: 'item-container',
  initialize: function(){
  	this.model.bind('change',this.render,this);
  },
  render: function(){
  	var self = this;
    this.$el.append(self.image())
        .append(self.info())
        .append(self.btns());
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
    $brand = $('<p></p>').html('brand: '+model.get('brand'));
    $tags = $('<p></p>').html('tags: '+model.get('tags'));
    $info.append($brand)
        .append($tags);
    return $info;
  },
  btns: function(){
  	var editURL = '/admin/items/' + this.model.get('id').toString() + '/edit';
  	var $btns = $("<div class='btn-group'></div>");
  	var $editBtn = $("<button class='btn btn-small edit-btn'></button>")
  	    .html("<a href='" + editURL + "'>Edit</a>");
  	var $deleteBtn = $("<button class='btn btn-small delete-btn'>Delete</button>");
    return $btns.append($editBtn)
  	    .append($deleteBtn);
  }
})