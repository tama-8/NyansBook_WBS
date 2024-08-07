# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
olivia = Customer.find_or_create_by!(email: "olivia@example.com") do |customer|
  customer.name = "Olivia"
  customer.password = "password"
  customer.profile_image = ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/sample1.jpg"), filename:"sample1.jpg")
end

Post.create!(customer: olivia, content: "test",image:ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/sample1.jpg"), filename:"sample1.jpg"))


james = Customer.find_or_create_by!(email: "james@example.com") do |customer|
  customer.name = "James"
  customer.password = "password"
  customer.profile_image = ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/sample2.jpg"), filename:"sample2.jpg")
end

Post.create!(customer: james, content: "test",image:ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/sample2.jpg"), filename:"sample2.jpg"))

lucas = Customer.find_or_create_by!(email: "lucas@example.com") do |customer|
  customer.name = "Lucas"
  customer.password = "password"
  customer.profile_image = ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/sample3.jpg"), filename:"sample3.jpg")
end

Post.create!(customer: lucas, content: "test",image:ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/sample3.jpg"), filename:"ssample3.jpg"))