window.CouponCollectionView = Backbone.View.extend({
  tagName: 'tbody',
  className: 'coupons-tbody',
  template: _.template($('#coupon-collection-template').html()),
  render: function(){
    /*var self = this;
    _.each(this.model.models,function(point){
      self.$el.append(self.template(point.toJSON()));
    })*/
    return this.el;
  }
})