class Admin::PostsController < ApplicationController
    before_action :authenticate_admin!
    before_action :set_post, only: [:edit, :update, :destroy]

  def index
      if params[:query].present?
        @posts = Post.where("content LIKE ?", "%#{params[:query]}%")
                     .order(created_at: :desc)
                     .page(params[:page])
                     .per(10) # ページごとの表示件数を指定
      else
        @posts = Post.order(created_at: :desc).page(params[:page]).per(10)
      end
  end
  
  def show
    @post = Post.find(params[:id])
  end

  def edit
  end
  
  def destroy
      @post = Post.find(params[:id])
      @post.destroy
      redirect_to admin_posts_path, notice: '投稿が削除されました'
  end

  def update
    if params[:post][:remove_image] == '1'
        @post.image.purge
    end
    
    if @post.update(post_params)
      redirect_to admin_post_path(@post), notice: '投稿が更新されました。'
    else
      render :edit
    end
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:content, :image)
  end
end
