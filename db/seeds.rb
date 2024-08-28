# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# 管理者アカウントの作成
Admin.find_or_create_by!(email: "admin@admin") do |admin|
  admin.password = "password"
  admin.password_confirmation = "password"
end


# customer1
olivia = Customer.find_or_create_by!(email: "olivia@example.com") do |customer|
  customer.name = "オリビア"
  customer.password = "password"
  customer.profile_image = ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/sample1.jpg"), filename: "sample1.jpg")
end

Post.create!(customer: olivia, content: "test", image: ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/sample1.jpg"), filename: "sample1.jpg"))

# customer2
james = Customer.find_or_create_by!(email: "james@example.com") do |customer|
  customer.name = "ジェームズ"
  customer.password = "password"
  customer.profile_image = ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/sample2.jpg"), filename: "sample2.jpg")
end

Post.create!(customer: james, content: "test", image: ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/sample2.jpg"), filename: "sample2.jpg"))

# customer3
lucas = Customer.find_or_create_by!(email: "lucas@example.com") do |customer|
  customer.name = "ルーカス"
  customer.password = "password"
  customer.profile_image = ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/sample3.jpg"), filename: "sample3.jpg")
end

Post.create!(customer: lucas, content: "test", image: ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/sample3.jpg"), filename: "ssample3.jpg"))

# customer4
sakura = Customer.find_or_create_by!(email: "sakura@example.com") do |customer|
  customer.name = "さくら"
  customer.password = "password"
  customer.profile_image = ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/sample4.jpg"), filename: "sample4.jpg")
end

Post.create!(customer: sakura, content: "test", image: ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/sample4.jpg"), filename: "sample4.jpg"))

# customer5
kiki = Customer.find_or_create_by!(email: "kiki@example.com") do |customer|
  customer.name = "キキ"
  customer.password = "password"
  customer.profile_image = ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/sample5.jpg"), filename: "sample5.jpg")
end

Post.create!(customer: kiki, content: "test", image: ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/sample5.jpg"), filename: "sample5.jpg"))
