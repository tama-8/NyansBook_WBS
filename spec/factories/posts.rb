FactoryBot.define do
  factory :post do
    content { "This is a test post content" }
    image { Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/files/test_image.png'), 'image/png') }
    association :customer # ポストが顧客に紐づいている場合
  end
end