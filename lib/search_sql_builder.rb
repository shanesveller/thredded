class SearchSqlBuilder
  attr_reader :binds

  def initialize(query)
    @query = query
    @terms = SearchParser.new(query).parse
    @select = 'SELECT DISTINCT t.*'
    @from = 'FROM topics t'
    @where = ['t.messageboard_id = ?']
    @order_by = 'ORDER BY t.updated_at DESC'
    @binds = []
  end

  def build
    parse_by
    parse_in
    parse_text
    [@select, @from, 'WHERE', @where.join(' AND '), @order_by].join(' ')
  end

  private

  def is_quoted(term)
    term.count('"') == 2
  end

  def parse_in
    @terms.each do |term|

      if term.include? 'in:'
        category_name = term.split(':')[1]
        category = Category
          .find(:first, :conditions => ['lower(name) = ?', category_name.downcase])

        if category
          add_table('topic_categories tc')
          add_where('tc.category_id = ?')
          add_where('tc.topic_id = t.id')
          add_bind(category.id.to_s)
        end
      end
    end
  end

  def parse_text
    if search_text.present?
      add_table('posts p')
      add_where('t.id = p.topic_id')
      add_where("to_tsvector('english', p.content) @@ plainto_tsquery('english', ?)")
      add_bind(search_text.uniq.join(' '))

      search_text.each do |term|
        if (is_quoted(term))
          add_where('p.content like ?')
          add_bind(term.gsub('"', '%'))
        end
      end
    end
  end

  def parse_by
    @terms.each do |term|

      if term.include? 'by:'
        username = term.split(':')[1]
        user = User.where(name: username).first

        if user
          add_where('t.user_id = ?')
          add_bind(user.id.to_s)
        end
      end
    end
  end

  def search_text
    @search_text ||= @terms.keep_if { |term| term.exclude? ':' }
  end

  def add_bind(var)
    @binds.push(var)
  end

  def add_table(table)
    if @from.exclude? table
      @from = "#{@from}, #{table}"
    end
  end

  def add_where(clause)
    if @where.exclude? clause
      @where << clause
    end
  end
end
