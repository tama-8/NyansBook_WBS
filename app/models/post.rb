class Post < ApplicationRecord
    #ActiveStorage を使って画像を持たせる
  has_one_attached :image
  belongs_to :user
  
   def get_image
    unless image.attached?
      file_path = Rails.root.join('app/assets/images/no_image.png')
      image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
    end
    image
   end

 
  validates :content, presence: true
  
end
