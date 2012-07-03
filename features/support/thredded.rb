require 'database_cleaner'
DatabaseCleaner.strategy = :truncation

After do |scenario|
  DatabaseCleaner.clean
end

class Array
  def collect_every(n, fill=false, offset = 0)
    if block_given?
      while  offset < size
        ret = []

        if fill
          n.times do |x|
            if offset + x > size - 1 then ret << nil
            else  ret << self[offset + x] end
          end
        else
          n.times { |x| ret << self[offset + x] unless offset + x > size - 1 }
        end

        offset += n
        yield ret
        ret = nil
      end
    else

      ret = []
      while offset < size
        ret << []

        if fill
          n.times do |x|
            if offset + x > size - 1 then ret.last << nil
            else ret.last << self[offset + x]; end
          end
        else
          n.times { |x| ret.last << self[offset + x] unless offset + x > size - 1 }
        end

        offset += n
      end
      return ret
    end
  end
end
