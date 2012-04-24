require "coderay"

module SyntaxFilter

  def filtered_content
    content = String.new(super)
    content = content.to_s.gsub(/\<pre\>\<code( lang="(.+?)")?\>(.+?)\<\/code\>\<\/pre\>/m) do
      filter = $2.nil? ? :ruby : $2
      temp_code = $3.gsub(/&quot;/, '"').
        gsub(/&#39;/,"'").
        gsub(/&amp;/, "&").
        gsub(/&gt;/, ">").
        gsub(/&lt;/, "<").
        gsub(/\<br \/\>/, "")
      ::CodeRay.scan(temp_code, filter).div(:css => :class)
    end
    content.html_safe
  end

end
