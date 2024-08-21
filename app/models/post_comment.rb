class PostComment < ApplicationRecord
  belongs_to :customer
  belongs_to :post
  has_many :reports, as: :content
    
end
