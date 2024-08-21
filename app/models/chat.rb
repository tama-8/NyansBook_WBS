class Chat < ApplicationRecord
  belongs_to :customer
  belongs_to :room
  has_many :notifications, dependent: :destroy

  validates :message, presence: true, length: { maximum: 140 }

  # 受信者を取得するメソッドを定義
  def recipient
    # このチャットが属するルームに参加している他の顧客を取得
    room.customers.where.not(id: customer_id).first
  end
end
