#テスト用のユーザーオブジェクトを作成
FactoryBot.define do
  factory :customer do
    sequence(:email) { |n| "customer#{n}@example.com" }
    password { "password" }
    password_confirmation { "password" }
    name { "Test Customer #{rand(1000)}" } # 名前属性を追加
  end
end