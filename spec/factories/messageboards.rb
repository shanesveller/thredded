Factory.sequence(:messageboard_name) {|n| "messageboard#{n}" }
Factory.sequence(:messageboard_title) {|n| "Messageboard #{n}" }

Factory.define :messageboard do |f|
  f.name                { Factory.next :messageboard_name }
  f.description         "This is a description of the messageboard"
  f.theme               'default'
  f.security            'public'
  f.posting_permission  'anonymous'
  f.title               { Factory.next :messageboard_title }
end
