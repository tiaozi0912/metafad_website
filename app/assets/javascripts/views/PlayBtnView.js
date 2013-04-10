window.PlayBtnView = Backbone.View.extend({
  el:"#play",
  settings: {
    defaultColor:'dusk_blue',
    defaultBrand:'burberry',
    scrollTop:843
  },
  initialize:function(){
    var self = this;
    this.$el.find('.play-btn').click(function(){self.playBtnHandler()});
    this.$el.find('.cancel-btn').click(function(){self.cancelBtnHandler()});
  },
	playBtnHandler: function(){
		$('.play-btn').hide();
    $('.cancel-btn').show();
		this.collapseLogo();
		this.showOptions();
	},
  cancelBtnHandler: function(){
    $('.play-btn').show();
    $('.cancel-btn').hide();
    this.collapseOptions();
    this.showLogo();
  },
  showLogo: function(){
    this.$el.find('.img-container').removeClass('collapsed');
  },
  collapseLogo: function(){
    this.$el.find('.img-container').addClass('collapsed');
  },
  showOptions: function(){
    var self = this;
    var $halfCircle = $('#play .half-circle')
        .animate({'border-width':110,"opacity":1},'fast')
        .each(function(i,el){
          var link,a;
          if(i == 0){
            link = '#gallery/colors/' + self.settings.defaultColor;
            $a = $("<a></a>").attr('href',link)
                .html("<h3 class='color-btn'>Colors</h3>");
          }else{
            link = '#gallery/brands/' + self.settings.defaultBrand;
            $a = $("<a></a>").attr('href',link)
                .html("<h3 class='color-btn'>Brands</h3>");
            
          }
          $(this).html($a);
        });
    $('#play').on('click','#play .half-circle a',function(){
      self.cancelBtnHandler();
      self.$el.hide();
      self.showGallery();
    })
  },
  collapseOptions: function(){
    var $text = this.$el.find('h3')
        .remove();
    $('#play .half-circle').animate({'border-width':0,"opacity":0},'fast');
  },
  showGallery:function(){
    var self = this;
    $('#gallery-section').addClass('wall-bg');
    $('#gallery').fadeIn('slow',function(){
      $(window).scrollTop(self.settings.scrollTop);
    }); 
  }
})