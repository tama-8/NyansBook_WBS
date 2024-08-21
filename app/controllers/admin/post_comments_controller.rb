class Admin::PostCommentsController < ApplicationController
  def index
    # 1ページに10件表示
    @post_comments = PostComment.page(params[:page]).per(10)
  end

  def destroy
    @post_comment = PostComment.find_by(id: params[:id])
    if @post_comment
      @post_comment.destroy
      redirect_to admin_post_comments_path, notice: "コメントを削除しました。"
    else
      redirect_to admin_post_comments_path, alert: "コメントが見つかりませんでした。"
    end
  end
end
