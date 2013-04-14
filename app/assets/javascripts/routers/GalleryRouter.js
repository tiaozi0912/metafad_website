/* router begins */
var GalleryRouter = Backbone.Router.extend({
  routes: {
    'gallery/:category/:tag':"selectTag"
    //'gallery-section':'close'
  },
  selectTag: function(category,tag){
    var url = '/gallery/' + category;
    var tag = tag.replace(/_/," ");
    $.get(url,function(data){
      var polls = data.polls;
      if(this.gallery){
        this.gallery.set({category:category,currTag:tag,polls:polls});
      }else{
       this.gallery = new Gallery({category:category,currTag:tag,polls:polls});
       this.galleryView = new GalleryView({model:this.gallery});
      }
    });  
  }
});