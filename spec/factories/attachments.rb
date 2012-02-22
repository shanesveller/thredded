Factory.define :attachment do |f|
  include ActionDispatch::TestProcess
  f.attachment    fixture_file_upload('spec/samples/img.png', 'image/png')
  f.content_type  "image/png"
  f.file_size     1000
end

Factory.define :pdfpng, :parent => :attachment do |pdf|
  pdf.attachment  fixture_file_upload('spec/samples/pdf.png', 'image/png')
end

Factory.define :txtpng, :parent => :attachment do |txt|
  txt.attachment  fixture_file_upload('spec/samples/txt.png', 'image/png')
end

Factory.define :zippng, :parent => :attachment do |zip|
  zip.attachment  fixture_file_upload('spec/samples/zip.png', 'image/png')
end
