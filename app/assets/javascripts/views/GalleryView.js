Backbone.View.prototype.close = function(){
  console.log('Closing view:'+this);
  if(this.beforeClose){
    this.beforeClose();//extra clean up staff
  }
  this.remove();
  this.unbind();
}

window.GalleryView = Backbone.View.extend({ //model:Gallery
  settings:{
    transitionTime:600,
    categories: {'colors':{'default':'dusk blue'},
                 'brands':{'default':'burberry'}},
  },
  el: "#gallery",
  events: {
    'click .close-btn':"close"
  },
  initialize: function(){
    //console.log('gallery view initialized!');
    this.sectionHeight = 443;
    this.render();
    this.model.bind('change',this.render,this);
	},
  render: function(){
    this.hideHeader();
    this.renderTagView();
    this.renderTagListView();
    this.renderNavView();
    return this.el;
  },
  hideHeader: function(){
    var self = this;
    $(window).scroll(function(){
      var top = $('#gallery-section').offset().top - $('#header').height();
      $(window).scrollTop() >  top ? $('#header').fadeOut('fast') : $('#header').fadeIn('fast');
    });
  },
  close: function(e){
    this.$el.parents('#gallery-section').removeClass('wall-bg');
    this.$el.hide();
    $('#play').fadeIn('slow');
      /* still can't understand the animation behavior 
       * $('#gallery-section') must be a class of transition-config
       * jQuery animate should be applied to the height, then the scrollTop changes
       * and then able to use jQuery scrollTop animation
       *****************************************************/
      /*$('#gallery-section').animate({'height':self.sectionHeight},function(){
        $(this).css('height','auto');
        $('body').animate({scrollTop:$('#gallery-section').offset().top});
      });*/
  },
  //function is called when GalleryView is initialized or the model of GalleryView is changed
  renderTagView:function(){
    var self = this;
    this.tag = this.model.get('collection').where({isSelected:true})[0];
    /*if(!this.tagView){
      this.tagView = new TagView({model:this.tag});
    }else{
      console.log('tag view model reset!');
    }*/
    this.tagView = new TagView({model:this.tag});
    var $imageWall = this.$el.find('#image-wall');
    var $imgs = $imageWall.find('img.gallery-img');
    if($imgs.length){
      $imgs.fadeOut(this.settings.transitionTime,function(){
       self.showView($imageWall,self.tagView);
      });
    }else{
      self.showView($imageWall,self.tagView);
    }
  },
  renderTagListView: function(){
    var $sidebar = this.$el.find('#sidebar');
    var tagListView = new TagListView({model:this.model.get('collection')});
    this.showView($sidebar,tagListView);
  },
  showView:function($selector,view){
    $selector.html(view.render());
    return view;
  },
  renderNavView: function(){
    var $nav = this.$el.find('.nav');
    var model = this.model;
    var $btnGroup = $("<div class='btn-group'></div>");
    for(var category in this.settings.categories){
      var deft =  this.settings.categories[category].default;
      var link = '#gallery/' + category + '/' + deft;
      var $a = $("<a class='btn'></a>")
          .attr("href",link)
          .html(category);
      if(category == model.get('category')) $a.addClass('selected');
      $btnGroup.append($a);
    }
    $nav.html($btnGroup);
  }
});

window.TagListView = Backbone.View.extend({ //model:TagCollection
  tagName: "ul",
  initialize: function(){
    this.model.bind('reset',this.render,this);
    this.model.bind('change',this.render,this);
  },
  render: function(){
    this.remove();
    _.each(this.model.models,function(tag){
      var tagItemView = new TagItemView({model:tag});
      this.$el.append(tagItemView.render());
    },this);
    return this.el;
  }
});

window.TagItemView = Backbone.View.extend({ //model:Tag
  tagName: "li",
  className: "option",
  initialize: function(){
    this.template = _.template($('#gallery-tag-item-template').html());
    this.model.bind('change',this.render,this);
  },
  events: {
    'mouseenter a':'expand',
    'mouseleave a':'collapse'
  },
  render: function(){
    var tag = this.model;
    var isColor = ( tag.get('category') == 'colors' );
    this.$el.html(this.template(this.model.toJSON()));
    var $colorBlock = this.$el.find('.color-block');
    this.$el.find('a').attr('href',tag.get('url').replace(/\s/,"_"));
    if(tag.get('isSelected')){
      this.$el.addClass('selected');
      $colorBlock.addClass('expand');
    }
    if(isColor){
      $colorBlock.css('background-color',this.model.get('rgb'));
      this.$el.addClass('color');
    }else{
      this.$el.addClass('brand');
    }
    //this.hover();
    return this.el;
  },
  expand: function(e){
    var target = e.currentTarget;
    if(!this.selected) this.selected = $('.color-block.expand');
    this.selected.removeClass('expand');
    $(target).find('.color-block').addClass('expand');
  },
  collapse: function(e){
    var target = e.currentTarget;
    $(target).find('.color-block').removeClass('expand');
    this.selected.addClass('expand');
  }
});

