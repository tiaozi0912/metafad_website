//validate user and retailer pre sign up form
(function($){
  'user strict'
  $.fn.validateForm = function(){
    $.fn.validateText = function(){
      var $obj = this;
      var text = $obj.val();
      var isEmpty = (text == "");
      //add error msg if it is not validated
      if(isEmpty){
        var name = $obj.siblings('label').html();
        var msg = name + " can't be empty.";
        $obj.showErrorMsg(msg);
      }
      return !isEmpty;
    }
    $.fn.validateEmail = function(){
      var $obj = this;
      var email = $obj.val();
      var re = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
      var isValidated = re.test(email);
      //add error msg if it is not validated
      if(!isValidated){
        var msg = "The email address is invalid";
        $obj.showErrorMsg(msg);
      }
      return isValidated;
    }
    $.fn.validateWebsite = function(){ //not using for now
      var $obj = this;
      var website = $obj.val();
      var urlregex = new RegExp(
            "^(http|https|ftp)\://([a-zA-Z0-9\.\-]+(\:[a-zA-Z0-9\.&amp;%\$\-]+)*@)*((25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[1-9])\.(25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[1-9]|0)\.(25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[1-9]|0)\.(25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[0-9])|([a-zA-Z0-9\-]+\.)*[a-zA-Z0-9\-]+\.(com|edu|gov|int|mil|net|org|biz|arpa|info|name|pro|aero|coop|museum|[a-zA-Z]{2}))(\:[0-9]+)*(/($|[a-zA-Z0-9\.\,\?\'\\\+&amp;%\$#\=~_\-]+))*$");
      var isValidated = urlregex.test(website);
      if(!isValidated){
        var msg = "The website address is not validated";
        $obj.showErrorMsg(msg);
      }
      return isValidated;
    }
    $.fn.showErrorMsg = function(msg){
      var $obj = this;
      var $parent = $obj.parent();
      var $msg = $("<div class='alert alert-error'></div>")
                 .html("<h3>"+msg+"</h3>");  
      $obj.after($msg);
    }

    return this.each(function(){
      var validated = true;
      var $form = $(this);
      var $inputs = $form.find('input');
      $form.find('.submit-btn').click(function(){ //start form validation
        $("form .alert-error").remove(); // remove the error messages if any
        $inputs.each(function(){
          var $input = $(this);
          if($input.attr('type') == 'text' || $input.attr('type') == 'email') validated =  $input.validateText() && validated;  //check if text is empty 
          if(validated){  // input text is not empty
            if($input.attr("type") == "email"){
              validated = $input.validateEmail() && validated;
            }
          }
        }); //all the inputs
        if(validated) $form.submit();
      }); //click the submit button
    });//each
  }//validateForm
})(jQuery);
