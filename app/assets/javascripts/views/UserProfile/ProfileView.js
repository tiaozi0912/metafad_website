window.ProfileView = Backbone.View.extend({ //model: user
  tagName:'div',
  className:'profile-container',
  initialize: function(){
    //this.model.fetch();
    this.model.on('change',this.render,this);
    this.model.on('reset',this.render,this);
  },
  render: function(){
    //console.log('user model is:');
    //console.log(this.model.toJSON());
    var tab = this.model.get('tab');
    this.template = _.template($('#'+ tab + '-template').html());
    this.$el.html(this.template(this.model.toJSON()));

    this.initCollectionView();

    this.$el.find('table').html(this.collectionView.render());
    return this.el;
  },
  initCollectionView: function(){
    var self = this;
    var tab = this.model.get('tab');
    var collections = this.model.get(tab);
    switch (tab){
      case 'points':
        self.collection = new PointCollection();
        _.each(collections,function(obj){
          self.collection.push(new Point(obj));
        });
        self.collectionView = new PointCollectionView({model:self.collection});
        break;
      case 'coupons':
        self.collection = new CouponCollection();
        _.each(collections,function(obj){
          self.collection.push(new Coupon(obj));
        });
        self.collectionView = new CouponCollectionView({model:self.collection});
        break;
      case 'stores':
        self.collection = new StoreCollection();
        _.each(collections,function(obj){
          self.collection.push(new Store(obj));
        });
        self.collectionView = new StoreCollectionView({model:self.collection});
        break;
      default:
        console.log('Error: there is no such tab.');
    }
  }
})