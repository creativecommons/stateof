(function ($) {
  "use strict";

  $(document).ready(function() {
    jQuery(".post-toggle").click(function() {
      var ID = $(this).data('post-id');
      var openText = $(this).data('open-text');
      var closedText = $(this).data('closed-text');
      jQuery(this).closest('.mkdf-parallax-section-holder').css('height','auto');
      jQuery(".more-content-" + ID ).toggleClass("open");
      jQuery("#post-body-" + ID ).slideToggle("slow");
      jQuery(this).text( jQuery(".more-content-" + ID ).hasClass("open") ? openText : closedText);
    });

    $('#intro .post-toggle').click();
  });

})(jQuery);