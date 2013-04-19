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
      self.pollView.remove();
      $(this).hide();
      $('#featured-polls').show();
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
      $('#featured-polls').hide();
      $('#poll-view-wrapper').html(self.pollView.render());
      $('#featured-polls-section .close-btn').show();
    })
  }
});

