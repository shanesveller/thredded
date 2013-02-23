class SearchParser
  def initialize(query)
    @query = query
    @keywords = ['in', 'by', 'order']
  end

  def parse
    parse_keywords.concat(parse_text)
    #['Alpine', 'Spring', '"Alpine Spring"', 'in:Beer', 'by:shaun']
  end

  def parse_keywords
    found_terms = []

    @keywords.each do |keyword|
      regex = Regexp.new(keyword+'\s*:\s*\w+')
      found_for_keyword = @query.scan(regex)
      @query = @query.gsub(regex, '')
      if found_for_keyword.present?
        found_terms.concat( found_for_keyword )
      end
    end

    found_terms = found_terms.map {|term| term.gsub(' ', '') }
    found_terms.uniq
  end

  def parse_text
    regex = Regexp.new('\"[^"]*\"')
    found_terms = @query.scan(regex)
    @query = @query.sub(regex,'')
    found_terms.concat( @query.split(/\s+/) )
  end
end
