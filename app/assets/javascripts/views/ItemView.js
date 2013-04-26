window.ItemView = Backbone.View.extend({ //model:item
  tagName: 'div',
  className: 'item-container shadow-subtle',
  settings: {
    admin: false,
    voteEnabled: true,
    result: true //the user can see the poll result
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
  	this.model.on('change',this.render,this);
  },
  render: function(){
  	var self = this;
    $.extend(self.settings,self.options.settings);
    this.$el.html(this.template(this.model.toJSON()));
    if (!this.settings.admin) this.$el.find('.btn-group').remove();
    if(!this.settings.voteEnabled) this.$el.find('.mask').remove();
    if(!this.settings.result) this.$el.find('.poll-result').remove();
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
    var self = this;
    var target = e.currentTarget;
    var url = '/featured_polls/items/' + this.model.get('id') + '/update';
    //var $votedIcon = $("<img src='/images/icons/red-heart.png' class='icon' id='voted' alt='red heart'>");

    //update the number of votes
    var count = parseInt(this.model.get('number_of_votes')) + 1;
    //$(target).siblings('h3').html(count.toString());
    $.post(url,{'item':{'number_of_votes': count}},function(data){
        if(data.errors){
          console.log(data.errors);
        }else{
          if (!self.settings.result){ //remind to sign in to view the poll results
            $('.modal .alert').remove();
            $('#sign-in-modal').modal();
            $('#notice-container').html("<h3 class='alert alert-warning'>Sign in to see the voting result. Plus, you can receive <b>500</b> points for coupons today!</h3>");
          }else{ // for the signed in user
            var votes_count = self.model.get('number_of_votes') + 1;
            var $redHeart = $("<img src='/images/icons/red-heart.png' alt='red heart'>")
                .addClass('icon inline-block');
            self.$el.find('.poll-result h3').html($redHeart)
              .append(votes_count);
            alert('Cool, you are definitely the trend setter!');
          } 
        }
    });
    $(target).attr('src','/images/icons/red-heart.png'); 

    //attach the voted icon to the item 
    //$(target).parents('.img-container').append($votedIcon);
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