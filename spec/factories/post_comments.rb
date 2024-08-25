FactoryBot.define do
  factory :post_comment do
    comment { "This is a test comment" }  # 正しい属性名を使用
    association :post
    association :customer
  end
end
