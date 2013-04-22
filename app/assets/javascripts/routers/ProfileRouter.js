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
    this.selectTab(tab);
    this.user = new User({id:id,tab:tab});
    this.profileView = new ProfileView({model:this.user});
    this.profileView.model.fetch({ //fetch will change/reset the model, which will call view.render automatically
      success: function(){
        $('#content-container').html(self.profileView.el);
      }
    });
  },
  selectTab: function(tab){  
    var $li;
    $('.nav-tabs li').removeClass('active');
    switch (tab){
      case 'coupons':
        $li = $('.nav-tabs li:nth-child(2)');
        break;
      case 'stores':
        $li = $('.nav-tabs li:nth-child(3)');
        break;
      default:
        $li = $('.nav-tabs li:first-child');
    }
    $li.addClass('active')
  }
});

