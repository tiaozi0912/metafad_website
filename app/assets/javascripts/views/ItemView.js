window.ItemView = Backbone.View.extend({ //model:item
  tagName: 'div',
  className: 'item-container shadow-subtle',
  settings: {
    admin: false,
    voteEnabled: true
  },
  events:{
    'mouseenter .img-container':'showMask',
    'mouseleave .img-container':'hideMask',
    'click .mask .icon':'vote',
    'mouseenter .mask .icon':'redHeart',
    'mouseleave .mask .icon':'whiteHeart'
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
  },
  vote: function(e){
    var target = e.currentTarget;
    var url = '/gallery_items/' + this.model.get('id') + '/update';
    var $votedIcon = $("<img src='/images/icons/red-heart.png' class='icon' id='voted' alt='red heart'>");

    //update the number of votes
    var count = parseInt($(target).siblings('h3').html()) + 1;
    $(target).siblings('h3').html(count.toString());
    $.post(url,{'item':{'number_of_votes': count}},function(data){
       if(data.errors){
          console.log(data.errors);
       }
    });
    $(target).attr('src','/images/icons/red-heart.png'); 

    //attach the voted icon to the item 
    $(target).parents('.img-container').append($votedIcon);
  },
  redHeart: function(e){
    var target = e.currentTarget;
    $(target).attr('src','/images/icons/red-heart.png'); 
  },
  whiteHeart: function(e){
    var target = e.currentTarget;
    $(target).attr('src','/images/icons/white-heart.png'); 
  }
})