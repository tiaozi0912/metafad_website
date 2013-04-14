window.TagView = Backbone.View.extend({ //model:Tag
  tagName: 'div',
  className: 'row-fluid',
  template: _.template($('#gallery-tag-template').html()),
  settings:{
    transitionTime : 3000,
    hoverTransitionTime: 600,
    maxRotationAngle: 3
  },
  r: {},
  initialize: function(){
    this.model.bind('change',this.render,this);
  },
  render: function(){
    var self = this;
    self.fadeIn();
    self.hover();
    return this.el;
  },
  reset: function(){
    var self = this;
    var $imgs = $('#image-wall').find('img');
    $imgs.animate({'opacity':0},this.settings.transitionTime,null,function(){
      $('#image-wall').remove();
    });
  },
  fadeIn:function(){
    var self = this;
    this.$el.html(this.template());
    var $imgContainers = this.$el.find('.img-container');
    var photoCollection = this.model.get('collection');
    $imgContainers.each(function(i){
      var photo = photoCollection.at(i);
      var name = photo.get('category') + "-" + photo.get('tag').replace(/\s/,"-") + "-" + photo.get('name');
      var $img = $('<img>').attr({src:photo.get('src')})
          .addClass('gallery-img')
          .addClass(name);
      var $pin = $("<div class='pin shadow'></div>");
      var $mask = self.mask($img);
      self.rotate($img,name);
      $(this).append($img)
          .append($pin)
          .append($mask);
    });
    this.$el.find('img').fadeIn(this.settings.transitionTime);
  },
  mask: function($img){
    var $mask = $("<div class='mask hide'></div>");
    $mask.html(_.template($('#gallery-mask-template').html()));
    return $mask;
  },
  rotate: function($img,name){
    var k = 10;
    var count = 2 * this.settings.maxRotationAngle * k + 1;
    var angleVal = Math.floor((Math.random()*count)-this.settings.maxRotationAngle * k) / k;
    this.r[name] = this.rotateProperty(angleVal);
    $img.css(this.r[name]);
  },
  rotateProperty: function(num){
    var angle = "rotate(" + num.toString() + "deg)";
    return {
      "transform": angle,
      "-webkit-transform":angle,
      "-ms-transform": angle,
      "-moz-transform":angle,
      "-o-transform": angle
    };
  },
  hover: function(){
    var self = this;
    $('#image-wall').on({
      mouseover: function(){
        var $mask = $(this).find('.mask');
        var $img = $(this).find('.gallery-img');
        $img.css(self.rotateProperty(0));
        //$container.
        $mask.height($img.outerHeight());
        $mask.width($img.outerWidth());
        $mask.removeClass('hide');
      },
      mouseout: function(){
        var $mask = $(this).find('.mask');
        var $img = $(this).find('.gallery-img');
        var name = $img.attr('class')
          .replace(/gallery-img/,"")
          .replace(/\s/g,'');
        
        $mask.addClass('hide');
        
        $img.css(self.r[name]);
      }
    },'.img-container');
    //listener to the heart icon
    $('#image-wall').on('click','.mask-content .icon',function(){
      $(this).attr('src','/images/icons/red-heart.png');
      $(this).parents('.img-container').find('.gallery-img').css('border-color','rgb(220,0,0)');
    });
  }
})
