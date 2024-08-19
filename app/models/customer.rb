class Customer < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
   
  has_one_attached :image      
  has_many :posts, dependent: :destroy
  has_many :post_comments, dependent: :destroy
  #いいね
  has_many :favorites
  has_many :favorite_posts, through: :favorites, source: :post
  # 自分がフォローする（与フォロー）側の関係性
  has_many :active_relationships, class_name: "Relationship",
                                   foreign_key: "follower_id",
                                   dependent: :destroy
  # 与フォロー関係を通じて参照→自分がフォローしている人
  has_many :following, through: :active_relationships, source: :followed
  # 自分がフォローされる（被フォロー）側の関係性
  has_many :passive_relationships, class_name: "Relationship",
                                   foreign_key: "followed_id",
                                   dependent: :destroy
  # 被フォロー関係を通じて参照→自分をフォローしている人
  has_many :followers, through: :passive_relationships, source: :follower
  has_many :customer_rooms, dependent: :destroy
  has_many :chats, dependent: :destroy  
  # チャット通知
  has_many :received_notifications, class_name: 'Notification', foreign_key: 'recipient_id', dependent: :destroy
  has_many :sent_notifications, class_name: 'Notification', foreign_key: 'sender_id', dependent: :destroy
  #通報
  has_many :reporter, class_name: "Report", foreign_key: "reporter_id", dependent: :destroy
  has_many :reported, class_name: "Report", foreign_key: "reported_id", dependent: :destroy
  # ゲストユーザー
  GUEST_USER_EMAIL = "guest@example.com"

  # name 属性のバリデーションが追加
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true

  # カスタムバリデーション
  validates :password, presence: true, confirmation: true, if: :password_required?

  def self.guest
    find_or_create_by!(email: GUEST_USER_EMAIL) do |customer|
      customer.password = SecureRandom.urlsafe_base64
      customer.name = "Guestuser"
    end
  end
  
  def guest_customer?
    email == GUEST_USER_EMAIL
  end
  
  has_one_attached :profile_image

  def get_profile_image(width, height)
    unless profile_image.attached?
      file_path = Rails.root.join('app/assets/images/no_image.png')
      profile_image.attach(io: File.open(file_path), filename: "no_image.png", content_type: 'image/png')
    end
    profile_image.variant(resize_to_limit: [width, height]).processed
  end

  # 検索機能
  def self.search_for(content, method)
    if method == 'perfect'
      Customer.where(name: content)
    elsif method == 'forward'
      Customer.where('name LIKE ?', content + '%')
    elsif method == 'backward'
      Customer.where('name LIKE ?', '%' + content)
    else
      Customer.where('name LIKE ?', '%' + content + '%')
    end
  end

  # フォロー機能
  # ユーザーのステータスフィードを返す
  def feed
      following_ids = "SELECT followed_id FROM relationships
                     WHERE  follower_id = :customer_id"
    Micropost.where("customer_id IN (#{following_ids})
                     OR customer_id = :customer_id", customer_id: id)
                     .includes(:user, image_attachment: :blob)
  end
  # ユーザーをフォローする
  def follow(other_customer)
    following << other_customer unless self == other_customer
  end

  # ユーザーをフォロー解除する
  def unfollow(other_customer)
    following.delete(other_customer)
  end

  # 現在のユーザーが他のユーザーをフォローしていれば true を返す
  def following?(other_customer)
    following.include?(other_customer)
  end

  private
  
  def password_required?
    new_record? || password.present?
  end
end
