window.StoreCollectionView = Backbone.View.extend({
  tagName: 'tbody',
  className: 'stores-tbody',
  template: _.template($('#store-collection-template').html()),
  render: function(){
    /*var self = this;
    _.each(this.model.models,function(point){
      self.$el.append(self.template(point.toJSON()));
    })*/
    return this.el;
  }
})