module BbcodeFilter
  require "bb-ruby"

  BB = {
    'Code' => [
      /\[code\](.*?)\[\/code\1?\]/mi,
      '<pre><code>\1</code></pre>',
      'Code Text',
      '[code]function(){ return true; }[/code]',
      :code],
    'Code with lang' => [
      /\[code:(.+)?\](.*?)\[\/code\1?\]/mi,
      '<pre><code lang="\1">\2</code></pre>',
      'Code Text',
      '[code]function(){ return true; }[/code]',
      :code],
    'Spoilers' => [
      /\[spoiler\](.*?)\[\/spoiler\1?\]/mi,
      '<blockquote class="spoiler">\1</blockquote>',
      'Spoiler Text',
      '[spoiler]Dumbledore dies[/spoiler]',
      :spoiler],
    'YouTube' => [
      /\[youtube\]http\:\/\/(www\.)?youtube.com\/((watch)?\?vi?=|embed\/)(.*?)\[\/youtube\1?\]/i,
      '<iframe class="youtube" width="560" height="315" src="//www.youtube.com/embed/\4?&rel=0&theme=light&showinfo=0&hd=1&autohide=1&color=white" frameborder="0" allowfullscreen="allowfullscreen"></iframe>',
      'Youtube Video',
      :video],
    'Quote' => [
      /\[quote(:.*)?=(?:&quot;)?(.*?)(?:&quot;)?\](.*?)\[\/quote\1?\]/mi,
      '</p><fieldset><legend><p>\2</p></legend><blockquote>\3</blockquote></fieldset><p>',
      'Quote with citation',
      "[quote=mike]Now is the time...[/quote]",
      :quote],
    'Quote (Sourceless)' => [
      /\[quote(:.*)?\](.*?)\[\/quote\1?\]/mi,
      '</p><fieldset><blockquote><p>\2</p></blockquote></fieldset><p>',
      'Quote (sourceclass)',
      "[quote]Now is the time...[/quote]",
      :quote]
  }

  def self.included(base)
    base.class_eval do
      Post::Filters << :bbcode
    end
  end

  def filtered_content
    self.filter.to_sym == :bbcode ? super.bbcode_to_html(BB, true, :disable, ).html_safe : super
  end
end
