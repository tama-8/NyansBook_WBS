class Public::ReportsController < ApplicationController
  before_action :authenticate_customer!

  def new
    content_type = params[:content_type].underscore
    @report = Report.new(content_id: params[:content_id], content_type: content_type)
  end

  def create
  @report = Report.new(report_params)
  @report.reporter_id = current_customer.id

  # content_typeとcontent_idから対応するオブジェクトを取得
  content = case @report.content_type
            when 'PostComment'
              PostComment.find_by(id: @report.content_id)
            when 'Post'
              Post.find_by(id: @report.content_id)
            else
              nil
            end

  if content.nil?
    flash[:alert] = "指定されたコンテンツが見つかりませんでした。"
    render :new
    return
  end

  @report.reported_id = content.customer_id

  if @report.save
    redirect_to public_post_path(content.is_a?(PostComment) ? content.post : content), notice: '通報が送信されました。'
  else
    render :new
  end

end


  private

  def report_params
    params.require(:report).permit(:reporter_id, :reported_id, :content_id, :content_type, :reason)
  end
end