window.PlayBtnView = Backbone.View.extend({
  el:"#play",
  settings: {
    defaultColor:'dusk_blue',
    defaultBrand:'burberry',
  },
  events: {
    'click .play-btn':'playBtn',
    'click .cancel-btn':'cancelBtn',
    'click .half-circle a':'showGallery'
  },
	playBtn: function(){
		$('.play-btn').hide();
    $('.cancel-btn').show();
		this.collapseLogo();
		this.showOptions();
	},
  cancelBtn: function(){
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
  },
  collapseOptions: function(){
    var $text = this.$el.find('.half-circle h3')
        .remove();
    $('#play .half-circle').animate({'border-width':0,"opacity":0},'fast');
  },
  showGallery:function(){
    this.cancelBtn();
    this.$el.hide();    
    $('#gallery-section').addClass('wall-bg');
    //wait until images are loaded
    $('#gallery .gallery-img').imagesLoaded(function(){
      console.log('images loaded!');
      //this.siblings('.loading').addClass('hide');
      $('#gallery').fadeIn('fast',function(){
        $('body').animate({scrollTop:$('#gallery-section').offset().top},'fast');
      });
    });
  }
})