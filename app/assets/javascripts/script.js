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

  // fit videos
  jQuery('article .content').fitVids();

  // check if we're on new topic / post page
  var form_new_topic = jQuery('form#new_topic,form#new_post');
  if (form_new_topic.length > 0) {
    // got a new attachment added, now we listen for that onchange
    form_new_topic.bind('nested:fieldAdded:attachments', function(e) {

      // what img # we up to?
      var seq_id = e.field.parent().find('.tag_id').length + 1;

      // to keep track of added images
      e.field.addClass('tag_id');
      e.field.attr('img-seq', seq_id);

      // bind on change, grab the ID from the attr then add tag
      e.field.bind('change', function(e) {
        var content = jQuery('textarea').val();
        var id =  jQuery(this).attr('img-seq');
        jQuery('textarea').val( content + '[t:img=' + id + ']' );
      });

    });

    // removed an attachment field
    form_new_topic.bind('nested:fieldRemoved', function(e) {
      // remove tracker class
      e.field.removeClass('tag_id');
      // get id from field
      var id = e.field.attr('img-seq');
      // get contents
      var content = jQuery('textarea').val();
      // replace tag and surrounding spaces with 1 space
      var tag_regex = new RegExp('\\s?\\[t:img=' + id + '\\]\\s?');
      var new_text = content.replace(tag_regex, ' ');
      new_text = adjust_tags(new_text, id);
      jQuery('textarea').val( new_text );
    });
  }  // end if (form_new_topic)

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

function adjust_tags(content, start) {
  // find tags
  var tags = content.match(/(\[t:img=\d+\])/g);

  if (tags) {
    for(var index in tags) {
      var tag = tags[index];
      var tag_num = tag.match(/(\d+)/)[0];

      // decrement if greater than starting tag
      if (tag_num > start) {
        var replace_with = tag.replace(tag_num, tag_num - 1);
        content = content.replace(tag, replace_with);
      }

    }

    // adjust attribute on elements img-seq
    var elements = jQuery('.tag_id');
    for(var i = 0; i < elements.length; i++) {
      var element = jQuery(elements[i]);
      var img_seq = element.attr('img-seq');
      if ( img_seq > start ) {
        element.attr('img-seq', img_seq - 1);
      }
    }
  }

  return content;
}
