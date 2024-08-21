# app/controllers/public/favorites_controller.rb
module Public
  class FavoritesController < ApplicationController
    # before_action :post_params

    def create
      @post = Post.find(params[:post_id])
      favorite = @post.favorites.new(customer_id: current_customer.id)
      favorite.save
    end

    def destroy
      @post = Post.find(params[:post_id])
      favorite = @post.favorites.find_by(customer_id: current_customer.id)
      favorite.destroy
    end
  end
end
