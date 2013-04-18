/* router begins */
var GalleryRouter = Backbone.Router.extend({
  routes: {
    'polls/:category/:title':"selectTag"
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
        self.poll.set({category:category,currTag:tag,polls:polls});
      }else{
       console.log('initialize gallery model');
       console.log('initialize gallery view');
       self.poll = new Poll({category:category,currTag:tag,polls:polls});
       self.pollView = new SinglePollView({model:self.gallery});
      }
    });  
  }
});