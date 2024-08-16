class Public::ReportsController < ApplicationController
    before_action :authenticate_customer!

  def new
      @report = Report.new(content_id: params[:content_id], content_type: 'PostComment')
  end

  def create
  @report = Report.new(report_params)
  @report.reporter = current_customer # ログインしている顧客を通報者として設定

  # 通報対象のコメントの投稿者を通報される人として設定
  post_comment = PostComment.find(@report.content_id)
  @report.reported = post_comment.customer
  
  if @report.save
    redirect_to public_post_path(@report.content.post), notice: '通報が送信されました。'
  else
    Rails.logger.debug @report.errors.full_messages
    render :new
  end
end

  private

  def report_params
    params.require(:report).permit(:reporter_id, :reported_id, :content_id, :content_type, :reason)
  end
end

