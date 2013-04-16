window.TagView = Backbone.View.extend({ //model:Tag
  tagName: 'div',
  className: 'row-fluid tag-view',
  template: _.template($('#gallery-tag-template').html()),
  settings:{
    transitionTime : 3000,
    hoverTransitionTime: 600,
    maxRotationAngle: 3
  },
  r: {},
  /*events: {
    'mouseover .img-container':'showMask',
    'mouseout .img-container':'hideMask',
    'click .mask-content .icon':'vote',
  },*/
  initialize: function(){
    this.bindEvents();
    this.model.bind('change',this.render,this);
    this.model.bind('reset',this.render,this);
  },
  bindEvents: function(){
    var self = this;
    $('body').on({
      mouseover: function(){ self.showMask(this)},
      mouseout: function(){self.hideMask(this)}
    },'.tag-view .img-container');
    // hack way to unbound delegate event
    $('body').off('click','.mask-content .icon');
    $('body').on('click','.mask-content .icon',function(){
      self.vote(this);
    })
  },
  render: function(){
    this.photosView();
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
    //this.$el.find('img').fadeIn(this.settings.transitionTime);
    this.$el.find('.gallery-img').imagesLoaded(function(){
      console.log('tag view photo loaded!');
      this.siblings('.loading').addClass('hide');
      this.fadeIn(self.settings.transitionTime);
    });
  },
  photoView: function(photo,$imgContainer){
    var $img = $('<img>').attr({src:photo.get('photo_url')})
        .addClass('gallery-img')
        .attr('id',photo.get('id'))
        .css('display','auto');
    var $pin = $("<div class='pin shadow'></div>");
    var $mask = this.mask(photo);
    var $loading = $("<img class='loading small' src='/images/icons/loading.gif'>");
    var name = photo.get('id');
    this.rotate($img,name);
    $imgContainer.append($img)
        .append($pin)
        .append($mask)
        .append($loading);
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
  showMask: function(target){
    //var target = e.currentTarget;
    var $mask = $(target).find('.mask');
    var $img = $(target).find('.gallery-img');
    $img.css(this.rotateProperty(0));
    $mask.height($img.outerHeight());
    $mask.width($img.outerWidth());
    $mask.removeClass('hide');
  },
  hideMask: function(target){
    //var target = e.currentTarget;
    var $mask = $(target).find('.mask');
    var $img = $(target).find('.gallery-img');
    var name = $img.attr('id');
    $mask.addClass('hide');
    $img.css(this.r[name]);
  },
  vote: function(target){
    //var target = e.currentTarget;
    var itemID = $(target).parents('.img-container').find('.gallery-img').attr('id').replace(/gallery-item-/,'');
    var url = '/gallery_items/' + itemID + '/update';
    //update the number of votes
    var count = parseInt($(target).siblings('h3').html()) + 1;
    $(target).siblings('h3').html(count.toString());
    $.post(url,{'item':{'number_of_votes': count}},function(data){
       if(data.errors){
          console.log(data.errors);
       }
    });
    $(target).attr('src','/images/icons/red-heart.png');
    $(target).parents('.img-container').find('.gallery-img').css('border-color','rgb(220,0,0)'); 
  }
});



