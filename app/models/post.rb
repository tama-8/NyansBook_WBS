class Post < ApplicationRecord
    #ActiveStorage を使って画像を持たせる
  has_one_attached :image
  belongs_to :user

  validates :title, presence: true
  validates :content, presence: true
  
end
