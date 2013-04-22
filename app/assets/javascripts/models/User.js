window.User = Backbone.Model.extend({
	initialize: function(){
    this.urlRoot = '/web/profile/' + this.get('tab');
	}
}); 

window.Point = Backbone.Model.extend(); 

window.PointCollection = Backbone.Collection.extend({
  model:Point
})

window.Coupon = Backbone.Model.extend(); 

window.PointCollection = Backbone.Collection.extend({
  model:Coupon
})