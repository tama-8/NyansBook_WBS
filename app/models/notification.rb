class Notification < ApplicationRecord
  belongs_to :sender, class_name: 'Customer', foreign_key: 'sender_id'
  belongs_to :recipient, class_name: 'Customer', foreign_key: 'recipient_id'
  belongs_to :chat
  
  scope :unread, -> { where(read: false) }
end
