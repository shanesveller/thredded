jQuery(document).ready(function() {

  adjust_timestamps();
  jQuery.timeago.settings.allowFuture = true;
  jQuery("abbr.timeago").timeago();

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

function pad(number, length) {
    var str = '' + number;
    while (str.length < length) { str = '0' + str; }
    return str;
}

function adjust_timestamps () {
  var offset = String($('body').data('tz-offset')), 
      sign = "",
      first_char = String(offset.substring(0, 1));

  if ( parseInt(first_char) > 0) {
    sign = "+"
  } else if( first_char == "-" ) {
    sign = "-";
    offset = offset.substring(1);
  } else {
    sign = "-";
    offset = "0"
  }

  offset = parseInt(offset)*100;
  offset = pad(offset, 4);
  offset = sign + offset;

  jQuery("abbr.timeago").each(function(){
    timestamp = jQuery(this).attr('title');
    timestamp += offset;
    jQuery(this).attr('title', timestamp);
  });
}
