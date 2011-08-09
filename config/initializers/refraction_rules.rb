Refraction.configure do |req|
    unless req.path =~ /\.css|\.png|\.jpg|\.gif|\.js/
      if req.host =~ /(site0|site1|thredded|mi|ja)\.thredded\.dev/
          req.rewrite! :host => 'thredded.dev', :port => req.port, :path => "/#{$1}#{req.path == '/' ? '' : req.path}"
      end
    end  
end

