//define category: brand, catwalk, street
/* router begins */
var ProfileRouter = Backbone.Router.extend({
  routes: {
    'users/:id/:tab':"user"
  },
  initialize: function(){
    Backbone.emulateHTTP = true;
    Backbone.emulateJSON = true;
  }
  user: function(id,tab){ //tab:points,coupons,stores
    this.user = new User({id:id,tab:tab});
    this.profileView = new ProfileView({model:this.user});
    $('#content-container').html(this.profileView.render());
  }
});

