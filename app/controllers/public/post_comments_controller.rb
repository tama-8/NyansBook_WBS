class Public::PostCommentsController < ApplicationController
    
  def create
    post = Post.find(params[:post_id])
    comment = post.post_comments.new(post_comment_params)
    comment.customer_id = current_customer.id
    if comment.save
      redirect_to public_post_path(post)
    else
      flash[:error] = "コメントを保存できませんでした"
      redirect_to public_post_path(post)
    end
  end
  
  def destroy
    PostComment.find(params[:id]).destroy
    redirect_to public_post_path(params[:post_id])
  end

  private

  def post_comment_params
    params.require(:post_comment).permit(:comment)
  end
end