class Post < ApplicationRecord
  # ActiveStorage を使って画像を持たせる
  has_one_attached :image
  has_many :post_comments, dependent: :destroy
  belongs_to :customer
  has_many :favorites, dependent: :destroy
  has_many :week_favorites, -> { where(created_at: ((Time.current.at_end_of_day - 6.day).at_beginning_of_day)..(Time.current.at_end_of_day)) }, class_name: "Favorite"
  has_many :reports, as: :content

  def get_image
    unless image.attached?
      file_path = Rails.root.join("app/assets/images/no_image.png")
      image.attach(io: File.open(file_path), filename: "default-image.jpg", content_type: "image/jpeg")
    end
    image
  end
  # 検索機能
  def self.search_for(content, method)
    if method == "perfect"
      Post.where(content: content)
    elsif method == "forward"
      Post.where("content LIKE ?", content + "%")
    elsif method == "backward"
      Post.where("content LIKE ?", "%" + content)
    else
      Post.where("content LIKE ?", "%" + content + "%")
    end
  end
  # いいね機能
  def favorited_by?(customer)
    favorites.where(customer_id: customer.id).exists?
  end

  validates :content, presence: true, length: { maximum: 200 }
  validates :image, presence: { message: "を選択してください" }
end
