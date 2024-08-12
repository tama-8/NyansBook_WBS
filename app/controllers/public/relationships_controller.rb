class Public::RelationshipsController < ApplicationController
   before_action :authenticate_customer!
  def create
    @customer = Customer.find(params[:customer_id])
     relationship = Relationship.create(follower_id: current_customer.id, followed_id: @customer.id)
  
     respond_to do |format|
      format.js   # 非同期リクエストに対応
     end
    # current_customer.follow(customer)
		# redirect_to request.referer
  end

  def destroy
    @customer = Customer.find(params[:customer_id])
   relationship = current_customer.relationships.find_by(followed_id: @customer.id)
   relationship.destroy if relationship.present?
    # current_customer.relationships.find_by(followed_id: customer.id).destroy
		# redirect_to request.referer
  end
  
  def followings
     customer = Customer.find(params[:customer_id])
		@cusutomers = customer.followings
  end

  def followers
    customer = Customer.find(params[:customer_id])
		@customers = customer.followers
  end
end
