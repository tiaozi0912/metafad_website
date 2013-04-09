/*var shareOnFb = function(token){

  var sharedPoll = new Poll();
  $.post(sharedPoll.fbUrl,{
      access_token:token,
      message:sharedPoll.msg,
      poll:sharedPoll.url,
      image:sharedPoll.imgs
    }
  );
  //TODO:implement real call back function.
  alert('Successfully shared on Facebook!');
}*/

var shareOnFb = function(token){
  console.log(token);
  var username = "yujun.wu.98";
  var url = "https://graph.facebook.com/" + username + "/feed";
  $.post(url,{
      access_token:token,
      message:"hello world!"
    }
  );
}

function Poll(){
  var imageArr = [];
  imgUrls().forEach(function(value){
    var h = {};
    h['url'] = value;
    h['user_generated'] = true;
    imageArr.push(h);
  })
  this.msg = message();
  this.url = url();
  this.fbUrl = "https://graph.facebook.com/me/muse_me:share";
  this.imgs = imageArr;
}

function imgUrls(){
  var urls = [];
  var $images = $("meta[property='og:image']");
  $images.each(function(){
    urls.push($(this).attr('content'));
  })
  return urls;
}

function message(){
  var msg = $('#fb-share-modal #message').val();
	return msg;
}

function url(){
	return $("meta[property='og:url']").attr('content');
}

function addPhotoPreview(){
  var images = imgUrls();
  var num = Math.min(images.length,4);
  for(i = 0;i < num;i++){
    var imageSpan = "<div class='span3' id='span_" + i + "'><img src='" + images[i] +"'></div>"
    $('#photo-preview').append(imageSpan);
    setHeightWithWidth($('#photo-preview #span_' + i),1);
  }
}

function removePhotoPreview(){
  $('#photo-preview .span3').remove();
}
