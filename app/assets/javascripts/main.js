function setSize(selector){
  var h2w = 600/380;
  var width = $('.photo-container img').width();
  var height = width * h2w;
  $(selector).css('height',height);
};

function setFooterMargin(bodyHeight){
  var footHeight = 49;
  var correction = 30;
  windowHeight = $(window).height()-correction;
  if(bodyHeight < windowHeight){
    setFooterTopMargin = windowHeight - bodyHeight-footHeight; 
    $('#footer').css('margin-top',setFooterTopMargin);
  }
}

function setHeightWithWidth($selector,radio){
  var h = $selector.width() * radio;
  //hardcode for now
  h = 122;
  $selector.height(h);
}

function setItemImageHeight(){
  $('.item-image-container').each(
    function(){
      var padding = 0;
      $image = $(this).children('img.item');
      imageHeight = $image.height();
      if(imageHeight != 0){
        containerHeight = $(this).height() - padding;
        topMargin = 0.5*(containerHeight - imageHeight);
        //topMargin = containerHeight - imageHeight;
        if(topMargin > 0){
          $(this).css("background-color","white");
          $image.css("margin-top",topMargin);
        }
      }
    }
  );
}

//Return false if the form is not validated and show the error
function formValidate(title,$descriptions){
  var validated = true;
  var errorMsg;

  function validateTitle(){
    var charCount = 90;
    //var charCount = 100000000;
    $(".title-field .alert").remove();
    if(title.length > charCount || title == ""){
      validated = false;
      title.length > charCount ? errorMsg = "Describe your poll within 90 characters" : errorMsg = "Poll description can't be blank."
      var titleTooLong = generateErrorMsg(errorMsg);      
      $(".title-field").append(titleTooLong);
    }
  }

  function validateDescriptions(){ 
    var charCount = 100000;   
    $descriptions.each(function(index){
      $(this).siblings('.alert').remove();
      if($(this).val().length > charCount){
        validated = false;
        errorMsg = "Describe the item within 33 characters."  
        $(this).parent().append(generateErrorMsg(errorMsg));
      }
    })
  }

  function validateItemsNumber(){
    $('#fileupload .alert').remove();
    if($descriptions.length < 2){
      validated = false;
      errorMsg = 'Please at least add 2 items to the poll.';
      $('#fileupload').append('generateErrorMsg(errorMsg)');
    }
  }

  function generateErrorMsg(errorMsg){
    return "<div class='alert alert-error'>" + errorMsg + "</div>";
  }

  validateTitle();
  validateDescriptions();
  return validated;
}

function htmlText(text){
  return text.replace(/_/g," ");
}

function parsePointActionContent(text,poll_url){
  /* content format:
   * "for voting to \n " + poll.user.user_name + " \n " + poll.title + " poll"
   * "for creating \n " + poll.title + "\n poll."
   */
  var arr = text.match(/[^\n]+/g);
  if (arr[0] == 'for voting to '){
    var len1 = arr[1].length;
    var len2 = arr[2].length;
    var count1 = 2;//two whitespaces
    var count2 = 6; //two whitespaces and 'poll'
    var retailer = arr[1].substr(1,len1-count1);
    var pollTitle = arr[2].substr(1,len2-count2);
    text = "for voting on " + "<b>" + retailer + "</b>'s poll: " + "<a href='" + poll_url + "'>" + pollTitle + "</a>";
  }
  return text; 
}

function validateFileType(type){
  var validTypes = {
    'image/jpeg' : 1,
    'image/png' : 1
  }
  return validTypes.hasOwnProperty(type);
}

/* home page animation */
$(window).load(function(){  //after the background image is loaded
  $('#logo-container').animate({"top":0},600,null,function(){
      /*setTimeout(function(){
        $('#btns').animate({"top":225},400);
      },1000);*/
  });
})
/* home page animation done */

