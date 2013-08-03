jQuery(document).ready(function() {
  not_a_touch_device = !('ontouchstart' in document.documentElement)

  jQuery('article .content').
    find('a[href^="http://"], a[href^="https://"]').
    attr('target', '_blank');

  jQuery('[data-toggle]').click(function(){
    target = this.getAttribute('data-toggle');
    jQuery(target).toggleClass('toggle');
  })

  jQuery('.menu_shortcut').click(function(e){
    e.preventDefault();

    $('body').toggleClass('show-site-nav')
  });

  // prevent double click on submit buttons
  $('form').submit(function(e){
    $(this).find('input[type="submit"]').prop('disabled', true);
  });

  // timestamps
  jQuery.timeago.settings.allowFuture = true;
  jQuery("abbr.timeago").timeago();

  // chosen
  jQuery(".topic_form #topic_user_id, #topic_category_ids").chosen();

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
  if(not_a_touch_device){
    forum_bundings = []

    topic_bindings = [
      ['shift+t', 'New Topic', function(){ window.location.href = $('a:contains("new topic")').attr('href'); }],
      ['t', 'Go to topic listing', function(){ window.location.href = $('.topic_nav .topic_list a').attr('href'); }],
      ['p', 'Go to private topic listing', function(){ window.location.href = $('.topic_nav .private_topic_list a').attr('href'); }],
      ['f', 'Go to forum listing', function(){ window.location.href = '/'; }]
    ]

    post_bindings = [
      ['shift+t', 'New Topic', function(){ window.location.href = $('a:contains("new topic")').attr('href'); }],
      ['shift+r', 'Post Reply', function(){
        $.scrollTo('#post_content', 1000, {easing: 'easeInQuart'});
        jQuery('#post_content').focus();
        return false;
      }],
      ['t', 'Go to topic listing', function(){ window.location.href = $('.topic_nav .topic_list a').attr('href'); }],
      ['p', 'Go to private topic listing', function(){ window.location.href = $('.topic_nav .private_topic_list a').attr('href'); }],
      ['f', 'Go to forum listing', function(){ window.location.href = '/'; }],
      ['m', 'Toggle the markup/filter help', function(){ Pseudohelp.toggle(); }]
    ]

    jQuery('#messageboards').chaves();

    jQuery('.topics').chaves({
      childSelector: 'article',
      bindings: topic_bindings
    });

    jQuery('section.posts').chaves({ bindings: post_bindings });
  }

  if($('[data-latest-read]').length){
    scroll_to_post = $('body').data('latest-read');
    $.scrollTo('#post_'+scroll_to_post, 1000, {easing:'easeInQuart'} )

    if(not_a_touch_device){
      scroll_to_el = $('#post_'+scroll_to_post);

      jQuery('section.posts > article').removeClass('active');
      $.fn.chaves.active = scroll_to_el;
      $.fn.chaves.index = scroll_to_el.index();
      scroll_to_el.addClass('active');
    }
  }
});

function pad(number, length) {
    var str = '' + number;
    while (str.length < length) { str = '0' + str; }
    return str;
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
