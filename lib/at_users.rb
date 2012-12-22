class AtUsers
  def self.render(content, messageboard)
    at_names = AtNotificationExtractor.new(content).extract
    members = messageboard.members_from_list(at_names)
    members.each { |member|
      content.gsub!("@#{member}", %Q{<a href="/users/#{member}">@#{member}</a>})
    }
    content
  end
end
