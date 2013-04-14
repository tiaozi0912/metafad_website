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
    self.photosView();
    self.hover();
    self.vote();
    return this.el;
  },
  reset: function(){
    var self = this;
    var $imgs = $('#image-wall').find('img');
    $imgs.animate({'opacity':0},this.settings.transitionTime,null,function(){
      $('#image-wall').remove();
    });
  },
  photosView:function(){
    var self = this;
    this.$el.html(this.template());
    var $imgContainers = this.$el.find('.img-container');
    var photoCollection = this.model.get('collection');
    $imgContainers.each(function(i){
      var photo = photoCollection.at(i);
      self.photoView(photo,$(this));
    });
    this.$el.find('img').fadeIn(this.settings.transitionTime);
  },
  photoView: function(photo,$imgContainer){
    //var name = photo.get('category') + "-" + photo.get('tag').replace(/\s/,"-") + "-" + photo.get('name');
    var $img = $('<img>').attr({src:photo.get('photo_url')})
        .addClass('gallery-img')
        .attr('id',photo.get('id'));
    var $pin = $("<div class='pin shadow'></div>");
    var $mask = this.mask(photo);
    this.rotate($img,name);
    $imgContainer.append($img)
        .append($pin)
        .append($mask);
  },
  mask: function(photo){
    var $mask = $("<div class='mask hide'></div>");
    var link = photo.get('photo_url').replace(/small/,'large');
    $mask.html(_.template($('#gallery-mask-template').html()));
    $mask.find('.lightbox').attr('href',link)
      .attr('rel','lightbox['+photo.get('tag').replace(/\s/,"-")+']');
    $mask.find('h3').html(photo.get('number_of_votes'));
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
  },
  vote: function(){
    $('#image-wall').on('click','.mask-content .icon',function(){
      var itemID = $(this).parents('.img-container').find('.gallery-img').attr('id').replace(/gallery-item-/,'');
      var url = '/gallery_items/' + itemID + '/update';
      //update the number of votes
      var count = parseInt($(this).siblings('h3').html()) + 1;
      $(this).siblings('h3').html(count.toString());
      $.post(url,{'item':{'number_of_votes': count}},function(data){
         if(data.errors){
            console.log(data.errors);
         }
      });
      $(this).attr('src','/images/icons/red-heart.png');
      $(this).parents('.img-container').find('.gallery-img').css('border-color','rgb(220,0,0)');
    });
  }
});



