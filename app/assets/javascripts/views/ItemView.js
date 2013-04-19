window.ItemView = Backbone.View.extend({ //model:item
  tagName: 'div',
  className: 'item-container shadow-subtle',
  settings: {
    admin: false,
    voteEnabled: true
  },
  events:{
    'mouseenter .img-container':'showMask',
    'mouseleave .img-container':'hideMask'
  },
  initialize: function(){
    this.template = _.template($('#item-view-template').html());
  	this.model.bind('change',this.render,this);
  },
  render: function(){
  	var self = this;
    $.extend(self.settings,self.options.settings);
    this.$el.html(this.template(this.model.toJSON()));
    if (!this.settings.admin) this.$el.find('.btn-group').remove();
    if(!this.settings.voteEnabled) this.$el.find('.mask').remove();
    return this.el;
  },
  showMask: function(e){
    var target = e.currentTarget;
    $(target).find('.mask').stop(true,true).fadeIn();
  },
  hideMask: function(e){
    var target = e.currentTarget;
    $(target).find('.mask').stop(true,true).fadeOut();
  }
})