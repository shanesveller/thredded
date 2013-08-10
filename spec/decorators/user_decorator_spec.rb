require 'spec_helper'

describe UserDecorator, '#last_active_timeago' do
  it 'prints something ambiguous for nils' do
    user = build_stubbed(:user, last_sign_in_at: nil)
    decorated_user = UserDecorator.new(user)
    ambiguous_message = <<-eohtml.strip_heredoc.html_safe
      <abbr>
        not sure how long ago
      </abbr>
    eohtml

    expect(decorated_user.last_active_timeago).to eq ambiguous_message
  end

  it 'prints a human readable/formatted date' do
    new_years = Chronic.parse('Jan 1 2013 at 3:00pm')

    Timecop.freeze(new_years) do
      user = build_stubbed(:user, last_sign_in_at: new_years)
      decorated_user = UserDecorator.new(user)

      last_active_html = <<-eohtml.strip_heredoc.html_safe
        <abbr class="timeago" title="2013-01-01T20:00:00Z">
          2013-01-01 20:00:00 UTC
        </abbr>
      eohtml

      expect(decorated_user.last_active_timeago).to eq last_active_html
    end
  end
end

describe UserDecorator, '#created_at_timeago' do
  it 'prints something ambiguous for nils' do
    user = build_stubbed(:user)
    user.stubs(created_at: nil)
    decorated_user = UserDecorator.new(user)
    ambiguous_message = <<-eohtml.strip_heredoc.html_safe
      <abbr>
        not sure how long ago
      </abbr>
    eohtml

    expect(decorated_user.created_at_timeago).to eq ambiguous_message
  end

  it 'prints a human readable/formatted date' do
    new_years = Chronic.parse('Jan 1 2013 at 3:00pm')

    Timecop.freeze(new_years) do
      user = build_stubbed(:user, created_at: new_years)
      decorated_user = UserDecorator.new(user)

      created_at_html = <<-eohtml.strip_heredoc.html_safe
        <abbr class="timeago" title="2013-01-01T20:00:00Z">
          2013-01-01 20:00:00 UTC
        </abbr>
      eohtml

      expect(decorated_user.created_at_timeago).to eq created_at_html
    end
  end
end
