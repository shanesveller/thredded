jQuery(document).ready(function() {
  jQuery.timeago.settings.allowFuture = true;
  jQuery("abbr.timeago").timeago();

  jQuery('.handle a').bind('click', function(){
    
    jQuery('#attributes').slideDown('fast', function(){
      return true;
    });
    return false;
  });
});
