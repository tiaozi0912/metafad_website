/* router begins */
var GalleryRouter = Backbone.Router.extend({
  routes: {
    'gallery/:category/:tag':"selectTag",
    'gallery-section':'close'
  },
  selectTag: function(category,tag){
    if(this.gallery){
      this.gallery.set({category:category,currTag:tag});
    }else{
     this.gallery = new Gallery({category:category,currTag:tag});
     this.galleryView = new GalleryView({model:this.gallery});
    }
  },
  close: function(){
    $('#gallery').fadeOut('slow',function(){
      $('#gallery-section').removeClass('wall-bg');
      $('#play').fadeIn('slow');
    });
    //$('#gallery').addClass('hide'); 
  }
});