class Public::PostsController < ApplicationController
    
    def index
      @posts = Post.all
      
    end

    def show
      @post = Post.find(params[:id])
    end

    def new
      @post = Post.new
    end
      # 投稿データの保存
    def create
      @post = Post.new(post_params)
      @post.customer = current_customer # 現在の顧客を設定
      if @post.save
        flash[:notice] = '投稿成功しました'
        redirect_to public_posts_path
      else
        flash.now[:alert] = '投稿失敗しました: ' + @post.errors.full_messages.join(", ")
        render :new
      end
    end
      
    def edit
      @post = Post.find(params[:id])
    end

    def update
      @post = Post.find(params[:id])
      if @post.update(post_params)
        flash[:notice] = '投稿が更新されました'
        redirect_to public_post_path(@post)
      else
        flash.now[:alert] = '投稿の更新に失敗しました: ' + @post.errors.full_messages.join(", ")
        render :edit
      end
    end

    def destroy
      @post = Post.find(params[:id])
      @post.destroy
      flash[:notice] = '投稿が削除されました'
      redirect_to public_posts_path
    end

    private

    def post_params
      params.require(:post).permit(:content ,:image)
    end
end
