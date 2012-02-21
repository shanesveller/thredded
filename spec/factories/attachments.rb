Factory.define :attachment do |f|
  include ActionDispatch::TestProcess
  f.attachment    fixture_file_upload('spec/samples/img.png', 'image/png')
  f.content_type  "image/png"
  f.file_size     1000
end
