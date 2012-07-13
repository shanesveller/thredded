include ActionDispatch::TestProcess

FactoryGirl.define do
  factory :attachment do
    attachment    { fixture_file_upload('spec/samples/img.png', 'image/png') }
    content_type  "image/png"
    file_size     1000

    factory :pdfpng do
      attachment  { fixture_file_upload('spec/samples/pdf.png', 'image/png') }
    end
    factory :txtpng do
      attachment  { fixture_file_upload('spec/samples/txt.png', 'image/png') }
    end
    factory :zippng do
      attachment  { fixture_file_upload('spec/samples/zip.png', 'image/png') }
    end
  end
end

