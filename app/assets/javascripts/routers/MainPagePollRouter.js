//define category: brand, catwalk, street
/* router begins */
var MainPagePollRouter = Backbone.Router.extend({
  routes: {
    'polls/:id':"selectTag"
  },
  settings: {
    title: true,
    largeView: true
  },
  initialize: function(){
    var self = this;
    $('#featured-polls-section .close-btn').click(function(){
      var $btn = $(this);
      $('#featured-polls').slideDown(400);
     $('#poll-view-wrapper').animate({'height':0},'slow',function(){
        self.pollView.remove();
        $btn.hide();
        $(this).height('auto');
      });
      /*setTimeout(function(){
        $('#poll-view-wrapper').animate({'height':0},'slow',function(){
          self.pollView.remove();
          $btn.hide();
          $(this).height('auto');
        });
      },10);*/
      /*$('#featured-polls').slideDown('fast',function(){
        $('#poll-view-wrapper').animate({'height':0},'slow',function(){
          self.pollView.remove();
          $btn.hide();
          $(this).height('auto');
        }) 
      });*/
    })
  },
  selectTag: function(id){
    var self = this;
    var url = '/web/polls/' + id;
    $.get(url,function(data){
      self.poll = new Poll(data.poll);
      self.pollView = new PollView({model:self.poll,
                                    settings:self.settings
                                  });
      $('#poll-view-wrapper').html(self.pollView.render());
      $('#poll-view-wrapper').slideDown('fast',function(){
        $('#featured-polls-section .close-btn').show();
        $('#featured-polls').slideUp();
      });
    })
  }
});

