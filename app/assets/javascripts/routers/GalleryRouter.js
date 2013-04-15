/* router begins */
var GalleryRouter = Backbone.Router.extend({
  routes: {
    'gallery/:category/:tag':"selectTag"
    //'gallery-section':'close'
  },
  selectTag: function(category,tag){
    var self = this;
    var url = '/gallery/' + category;
    var tag = tag.replace(/_/," ");
    $.get(url,function(data){
      var polls = data.polls;
      if(self.gallery){
        console.log('gallery model changed!');
        self.gallery.set({category:category,currTag:tag,polls:polls});
      }else{
       console.log('initialize gallery model');
       console.log('initialize gallery view');
       self.gallery = new Gallery({category:category,currTag:tag,polls:polls});
       self.galleryView = new GalleryView({model:self.gallery});
      }
    });  
  }
});