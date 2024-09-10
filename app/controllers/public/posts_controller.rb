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
  #@post.score = Language.get_data(post_params[:content]) # テキスト感情指数

  if @post.save
    # 画像が投稿されている場合、感情分析を実行
    if @post.image.attached?
      # 画像を一時ディレクトリに保存
      image_path = Rails.root.join('tmp', @post.image.filename.to_s)
      File.open(image_path, 'wb') do |file|
        file.write(@post.image.download)
      end

      # Pythonスクリプトを実行して感情分析を行う
      result = ""
      begin
        IO.popen(["python3", "#{Rails.root}/app/python_scripts/analyze_emotion.py", image_path.to_s]) do |pipe|
          result = pipe.read.strip
        end

        # デバッグ用: 画像パスのログ出力
      Rails.logger.debug("一時保存された画像のパス: #{image_path}")

        # 感情分析結果をフラッシュメッセージで表示
        flash[:emotion_analysis_result] = "感情分析結果: #{result}"
      rescue => e
        Rails.logger.error("感情分析スクリプトの実行に失敗: #{e.message}")
        flash[:alert] = "感情分析に失敗しました"
      ensure
        # 一時ファイルを削除
        File.delete(image_path) if File.exist?(image_path)
      end
    end

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
    @post.score = Language.get_data(post_params[:content])#感情指数
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
