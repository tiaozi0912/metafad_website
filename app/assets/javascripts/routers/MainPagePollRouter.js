//define category: brand, catwalk, street
/* router begins */
var MainPagePollRouter = Backbone.Router.extend({
  routes: {
    'polls/:id':"selectTag"
  },
  settings: {
    title: true,
    closeBtn: true
  },
  selectTag: function(id){
    var self = this;
    var url = '/web/polls/' + id;
    $.get(url,function(data){
      self.poll = new Poll(data.poll);
      if(!self.pollView) self.pollView = new PollView({model:self.poll,
                                                            settings:self.settings
                                                          });
      $('#poll-view-wrapper').html(self.pollView.render());
    });
    this.closeBtn();
  },
});

