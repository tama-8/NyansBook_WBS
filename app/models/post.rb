class Post < ApplicationRecord
    #ActiveStorage を使って画像を持たせる
  has_one_attached :image
  has_many :post_comments, dependent: :destroy
  belongs_to :customer
  
   def get_image
    unless image.attached?
      file_path = Rails.root.join('app/assets/images/no_image.png')
      image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
    end
    image
   end
   # 検索機能
def self.search_for(content, method)
  if method == 'perfect'
    Post.where(content: content)
  elsif method == 'forward'
    Post.where('content LIKE ?', content + '%')
  elsif method == 'backward'
    Post.where('content LIKE ?', '%' + content)
  else
    Post.where('content LIKE ?', '%' + content + '%')
  end
end

 
  validates :content, presence: true
  validates :image, presence: { message: 'を選択してください' }
end
