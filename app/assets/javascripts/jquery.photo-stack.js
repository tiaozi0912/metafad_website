(function($){
  'user strict'
  $.fn.photoStack = function(options){
    var settings = jQuery.extend({
        height:260,
        width: 420,
        frameWidth: 10,
        frameColor: '#eee',
        frameHighlightColor: '#333',
        offsetX: 30,
        offsetY: 30,
        transitionTime:500,
        timeInterval: 6000
    },options);

    return this.each(function(){
        var $carousel = $(this);
        //setup the frame
        var $imgs = $carousel.find('img');
        var num = $imgs.length;
        var w = settings.width + settings.offsetX * ( num - 1 ) + settings.frameWidth * ( num + 1 );
        var h = settings.height + settings.offsetY * ( num - 1 ) + settings.frameWidth * ( num + 1 );

        $carousel.css({'position':'relative',
                     'height':h,
                      'width':w});
        $imgs.css({'position':'absolute',
                                  'height':settings.height,
                                  'width':settings.width,
                                  'border-style':'solid',
                                  'border-width':settings.frameWidth,
                                  'border-color':settings.frameColor
                                });

        //prepare for the transition animate
        $imgs.each(function(i,e){
          var $img = $(this);
          var top = i * settings.offsetY;
          var left = i * settings.offsetX;
          var index = -i;
          $img.css({ 'top':top,
                    'left':left,
                    'z-index':index
                  });
        });
        $carousel.hover(function(){
          $imgs.css('border-color',settings.frameHighlightColor)
        },function(){
          $imgs.css('border-color',settings.frameColor)
        });

        var intervalID = setInterval(imgAnimation,settings.timeInterval);
        function imgAnimation(){
          $imgs.each(function(i,e){
            var $img = $(this);
            var zIndex = parseInt($img.css('z-index'));
            var isOnTop = (zIndex == 0);
            zIndex = (isOnTop ? - num + 1 : zIndex + 1);
            var top = -zIndex * settings.offsetY;
            var left = -zIndex * settings.offsetX;
            var p = { 'top':top,
                      'left':left,
                      'z-index':zIndex
                    }
            $img.animate(p,settings.transitionTime);
            $img.css(p);
          });
        }
    });//each
  }//function
})(jQuery)