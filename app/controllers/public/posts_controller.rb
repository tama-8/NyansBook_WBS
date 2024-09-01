class Public::PostsController < ApplicationController
  before_action :authenticate_customer!
  before_action :correct_post, only: [:edit, :update]

  def index
    @posts = Post.order(created_at: :desc)  # 新規投稿順に並べ替え
  end

  def show
    @post = Post.find(params[:id])
    @post_comment = PostComment.new
 rescue ActiveRecord::RecordNotFound
   flash[:alert] = "指定された投稿が見つかりません。"
   redirect_to public_posts_path
  end

  def new
    @post = Post.new
  end

  # 投稿データの保存
  def create
    @post = Post.new(post_params)
    @post.customer = current_customer # 現在の顧客を設定
    @post.score = Language.get_data(post_params[:content])#感情指数
    if @post.save
      flash[:notice] = "投稿成功しました"
      redirect_to public_post_path(@post)
    else
      flash.now[:alert] = "投稿失敗しました: " + @post.errors.full_messages.join(", ")
      render :new
    end
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])
    if @post.update(post_params)
      flash[:notice] = "投稿が更新されました"
      redirect_to public_post_path(@post)
    else
      flash.now[:alert] = "投稿の更新に失敗しました: " + @post.errors.full_messages.join(", ")
      render :edit
    end
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    flash[:notice] = "投稿が削除されました"
    redirect_to public_customer_path(current_customer)
  end
  # ユーザーがいいねをした日時の降順（新しい順）
  def favorites
    @favorite_posts = current_customer.favorites.order(created_at: :desc).map(&:post)
  end

  private
    def post_params
      params.require(:post).permit(:content, :image)
    end

    def correct_post
      @post = Post.find(params[:id])
      unless @post.customer == current_customer
        flash[:alert] = "権限がありません。"
        redirect_to public_posts_path
      end
    rescue ActiveRecord::RecordNotFound
      flash[:alert] = "指定された投稿が見つかりません。"
      redirect_to public_posts_path
    end
end
