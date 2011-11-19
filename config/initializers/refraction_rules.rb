Refraction.configure do |req|

    unless req.path =~ /\.css|\.png|\.jpg|\.gif|\.js/ || req.path =~ /^\/users/

      default_domain  = THREDDED[:default_domain]
      subdomains      = Site.all.map{ |site| site.slug }.join '|'

      # build our regex for subdomains
      default_domain_regex  = ".#{default_domain}".gsub('.','\\\\.')
      subdomain_regex       = Regexp.new "(#{subdomains})#{default_domain_regex}"

      # first check for full domains
      if Site.exists?(:domain => req.host)
        domain = Site.where(:domain => req.host).first
        req.rewrite! :host => default_domain, :port => req.port, :path => "/#{domain.slug}#{req.path == '/' ? '' : req.path}"
      elsif req.host =~ subdomain_regex
        req.rewrite! :host => default_domain, :port => req.port, :path => "/#{$1}#{req.path == '/' ? '' : req.path}"
      end

    end  
end
