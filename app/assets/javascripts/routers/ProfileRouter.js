//define category: brand, catwalk, street
/* router begins */
var ProfileRouter = Backbone.Router.extend({
  routes: {
    'tab?=:tab/id?=:id':"user"
  },
  initialize: function(){
    Backbone.emulateHTTP = true;
    Backbone.emulateJSON = true;
  },
  user: function(tab,id){ //tab:points,coupons,stores
    var self = this;
    this.user = new User({id:id,tab:tab});
    this.profileView = new ProfileView({model:this.user});
    this.profileView.model.fetch({ //fetch will change/reset the model, which will call view.render automatically
      success: function(){
        $('#content-container').html(self.profileView.el);
      }
    });
  }
});

