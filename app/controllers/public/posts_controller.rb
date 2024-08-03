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
        if current_customer
          @post = Post.new(post_params)
          @post.customer_id = current_customer.id
          if @post.save
            redirect_to public_post_path(@post)
          else
            render :new
          end
        else
             redirect_to new_session_path, alert: 'You need to log in to create a post.'
        end
    end

    def edit
      @post = Post.find(params[:id])
    end

    def update
      @post = Post.find(params[:id])
      if @post.update(post_params)
        redirect_to public_post_path(@post)
      else
        render :edit
      end
    end

    def destroy
      @post = Post.find(params[:id])
      @post.destroy
      redirect_to public_posts_path
    end

    private

    def post_params
      params.require(:post).permit(:content ,:image)
    end
end
