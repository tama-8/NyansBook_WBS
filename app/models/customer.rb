class Customer < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
   
   has_one_attached :image      
   has_many :posts, dependent: :destroy
   has_many :post_comments, dependent: :destroy
   has_many :favorites, dependent: :destroy
  
  # 自分がフォローされる（被フォロー）側の関係性
  has_many :reverse_of_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  # 被フォロー関係を通じて参照→自分をフォローしている人
  has_many :followers, through: :reverse_of_relationships, source: :follower
  
  # 自分がフォローする（与フォロー）側の関係性
  has_many :relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  # 与フォロー関係を通じて参照→自分がフォローしている人
  has_many :followings, through: :relationships, source: :followed
   #ゲストユーザー
   GUEST_USER_EMAIL = "guest@example.com"
   #name 属性のバリデーションが追加
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
      profile_image.attach(io: File.open(file_path), filename:  "no_image.png" , content_type: 'image/png')
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
  #フォロー機能
  def follow(customer)
    relationships.create(followed_id: customer.id)
  end

  def unfollow(customer)
    relationships.find_by(followed_id: customer.id).destroy
  end

  def following?(customer)
    followings.include?(customer)
  end

  
  private
  
    def password_required?
      new_record? || password.present?
    end
end
