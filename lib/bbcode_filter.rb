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
    :code]
}
module BbcodeFilter
  require "bb-ruby"

  def self.included(base)
    base.class_eval do
      Post::Filters << :bbcode
    end
  end

  def filtered_content
    @filtered_content = self.filter.to_sym == :bbcode ? super.bbcode_to_html(BB).html_safe : super
  end

end
