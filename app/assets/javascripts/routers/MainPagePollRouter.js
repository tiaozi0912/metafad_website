//define category: brand, catwalk, street
/* router begins */
var MainPagePollRouter = Backbone.Router.extend({
  routes: {
    'featured-polls-section/polls/:id':"selectTag"
  },
  settings: {
    title: true,
    description:true,
    largeView: true,
    result:false
  },
  initialize: function(options){
    Backbone.emulateHTTP = true;
    Backbone.emulateJSON = true;
    $.extend(this.settings,options.settings);
    var self = this;
    $('#featured-polls-section .close-btn').click(function(){
      var $btn = $(this);
      $('#featured-polls').slideDown(400);
      $('#poll-view-wrapper').animate({'height':0},'slow',function(){
        self.pollView.remove();
        $btn.hide();
        $(this).height('auto');
        $(this).hide();
      });
    })
  },
  selectTag: function(id){
    var self = this;
    self.poll = new Poll({id:id});
    self.pollView = new PollView({model:self.poll,
                                  settings:self.settings
                                });
    self.poll.fetch();
    $('#poll-view-wrapper').html(self.pollView.$el);
    $('#poll-view-wrapper .item-image').imagesLoaded(function(){ //transitions
      $('#poll-view-wrapper').slideDown('fast',function(){
        $('#featured-polls-section .close-btn').show();
        $('#featured-polls').slideUp('fast',function(){ //scrollTop
          $('body').animate({scrollTop:$('#featured-polls-section').offset().top},'fast');
        });
        
      });
    })
    
    
  }
});

