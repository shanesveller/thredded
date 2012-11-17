When /^"([^"]*)" sends an email to "([^"]*)" with subject "([^"]*)" and body "([^"]*)"$/ do |user_email, board_email, email_subject, email_body|
  post mail_receive_path,
    'from' => user_email,
    'subject' => email_subject,
    'text' => email_body,
    'to' => board_email,
    'attachments' => '0'
end
