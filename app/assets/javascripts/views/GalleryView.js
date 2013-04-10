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
    categories: {'colors':{'default':'dusk_blue'},
                 'brands':{'default':'burberry'}},
  },
  el: "#gallery",
  initialize: function(){
    console.log('gallery view initialized!');
    //this.sectionHeight = $('#gallery-section').height();
    this.sectionHeight = 443;
    this.render();
    this.model.bind('change',this.render,this);
	},
  render: function(){
    this.hideHeader();
    this.renderTagView();
    this.renderTagListView();
    this.renderNavView();
    this.closeHandler();
    return this.el;
  },
  hideHeader: function(){
    var self = this;
    $(window).scroll(function(){
      var top = $('#gallery-section').offset().top - $('#header').height();
      $(window).scrollTop() >  top ? $('#header').fadeOut('fast') : $('#header').fadeIn('fast');
    });
  },
  closeHandler: function(){
    var self = this;
    self.$el.find('.close-btn').click(function(){
      $('#gallery-section').removeClass('wall-bg');
      self.$el.hide();
      $('#play').show();
      $('#gallery-section').animate({'height':self.sectionHeight},600,null,function(){
        $(this).css('height','auto');  
        $('body').animate({scrollTop:$('#gallery-section').offset().top});
      });
      
    }); 
  },
  renderTagView:function(){
    var self = this;
    this.tag = this.model.get('collection').where({isSelected:true})[0];
    if(!this.tagView){
      this.tagView = new TagView({model:this.tag});
    }
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
    if(this.currentView) this.currentView.close();
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
      /*if(photoRow.get('category') == 'colors'){
        this.$el.find('.color-label').css('background-color',photoRow.get('color'));
      }*/
      this.$el.append(tagItemView.render());
    },this);
    //this.$el.after("<div class='btn pull-right'>Brands</div>");
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
  render: function(){
    var tag = this.model;
    var isColor = ( tag.get('category') == 'colors' );
    this.$el.html(this.template(this.model.toJSON()));
    var $colorBlock = this.$el.find('.color-block');
    this.$el.find('a').attr('href',tag.get('url'));
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
    this.hover();
    return this.el;
  },
  hover: function(){
    $('body').on({
      mouseenter: function(){
        if(!this.selected) this.selected = $('.color-block.expand');
        this.selected.removeClass('expand');
        $(this).find('.color-block').addClass('expand');
      },
      mouseleave: function(){
        $(this).find('.color-block').removeClass('expand');
        this.selected.addClass('expand');
      }
    },'#sidebar li');
  }
});

