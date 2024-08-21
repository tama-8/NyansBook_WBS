class Relationship < ApplicationRecord
  belongs_to :follower, class_name: "Customer"
  belongs_to :followed, class_name: "Customer"

  validates :follower_id, presence: true
  validates :followed_id, presence: true

  before_validation :check_same_id

  private
    def check_same_id
      if self.follower_id == self.followed_id
        errors.add(:base, "not enter same id")
      end
    end
end
