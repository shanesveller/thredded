module TopicsHelper
  require 'digest/md5'
  
  def md5(s)
    Digest::MD5.hexdigest(s)
  end

end
