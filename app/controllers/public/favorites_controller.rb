# app/controllers/public/favorites_controller.rb
module Public
  class FavoritesController < ApplicationController
    def create
      post = Post.find(params[:post_id])
      @favorite = current_customer.favorites.new(post_id: post.id)
      @favorite.save
      render 'favorites/replace_btn'
    end

    def destroy
      post = Post.find(params[:post_id])
      @favorite = current_customer.favorites.find_by(post_id: post.id)
      @favorite.destroy
      render 'favorites/replace_btn'
    end
  end
end

