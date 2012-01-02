jQuery(document).ready(function() {
  jQuery.timeago.settings.allowFuture = true;
  jQuery("a.timeago, abbr.timeago").timeago();

  jQuery("#topics_new #topic_user_id").chosen();

  jQuery('.handle a').bind('click', function(){
    
    if (jQuery('#attributes').is(':hidden'))
    {
      jQuery('#attributes').slideDown('fast', function(){
        jQuery('.handle a').html('Less');
      });
    } else {
      jQuery('#attributes').slideUp('fast', function(){
        jQuery('.handle a').html('More');
      });
    }

    return false;
  });
});

