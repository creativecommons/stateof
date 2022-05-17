
(function ($) {
  "use strict";

  $(document).ready(function() {
    $(window).scroll(function() {
      var top = this.scrollY;
      if ($('.cc-sotc-mobile-slow-internet').is(":visible") == false){
        if (top < 40){
          $('.cc-sotc-mobile-slow-internet').show();
        }
      } else {
        if (top > 80){
          $('.cc-sotc-mobile-slow-internet').hide();
        }
      }
    });
  });

})(jQuery);

