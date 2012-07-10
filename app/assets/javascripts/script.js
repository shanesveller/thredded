jQuery(document).ready(function() {
  // timestamps
  adjust_timestamps();
  jQuery.timeago.settings.allowFuture = true;
  jQuery("abbr.timeago").timeago();
  // chosen
  jQuery("#topics_new #topic_user_id").chosen();
  // drawer under the topic field
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
  // chaves setup
  topic_bindings = [
    ['shift+t', 'New Topic', function(){ window.location.href = $('a:contains("Create a New Topic")').attr('href'); }]
  ]
  post_bindings = [
    ['shift+t', 'New Topic', function(){ window.location.href = $('a:contains("Create a New Topic")').attr('href'); }],
    ['shift+r', 'Post Reply', function(){
      window.location.hash = '#post_content';
      setTimeout("jQuery('#post_content').focus()", 100);
    }],
    ['t', 'Go to topic listing', function(){ window.location.href = $('nav.breadcrumbs li').eq(1).find('a').attr('href'); }]
  ]
  jQuery('section.topics').chaves({ bindings: topic_bindings });
  jQuery('section.posts').chaves({ bindings: post_bindings });
});

function pad(number, length) {
    var str = '' + number;
    while (str.length < length) { str = '0' + str; }
    return str;
}

function adjust_timestamps () {
  var offset = String($('body').data('tz-offset'));
  var sign = "";
  var first_char = String(offset.substring(0, 1));

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
