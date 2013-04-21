window.ProfileView = Backbone.View.extend({ //model: user
  tag:'div',
  className:'profile-tab',
  initialize: function(){
    this.model.on('change',this.render,this);
    this.model.on('reset',this.render,this);
    this.model.fetch();
  },
  render: function(){
    var $tab, tab = this.model.get('tab');
    switch (tab){
      case 'points':
        $tab = this.renderPoints();
        break;
      case 'coupons':
        $tab = this.renderCoupons();
        break;
      case 'stores':
        $tab = this.renderStores();
        break;
      default:
        console.log('Error: there is no such tab.');
    }
    this.$el.html($tab);
    return this.el;
  },
  renderPoints: function(){
    this.template = _.template($('#points-template').html());
    return this.template(this.model.toJSON());
  },
  renderCoupons: function(){
    this.template = _.template($('#coupons-template').html());
    return this.template(this.model.toJSON());
  },
  renderStores: function(){
    this.template = _.template($('#stores-template').html());
    return this.template(this.model.toJSON());
  }
})