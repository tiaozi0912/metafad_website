window.PointCollectionView = Backbone.View.extend({
  tagName: 'tbody',
  className: 'points-tbody',
  template: _.template($('#point-collection-template').html()),
  render: function(){
    var self = this;
    _.each(this.model.models,function(point){
      self.$el.append(self.template(point.toJSON()));
    })
    return this.el;
  }
})