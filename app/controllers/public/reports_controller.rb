class Public::ReportsController < ApplicationController
    before_action :authenticate_customer!

  def new
      @report = Report.new(content_id: params[:content_id], content_type: 'PostComment')
  end

  def create
    @report = Report.new(report_params)
    @report.reporter = current_customer

    # content_type に基づいて対応するモデルを動的に検索
    if @report.content_type == 'PostComment'
      content = PostComment.find_by(id: @report.content_id)
    else
      content = nil
    end

    if content.present?
      # 通報対象のコメントの投稿者を通報される人として設定
      @report.reported = content.customer
    else
      flash[:alert] = "通報対象のコンテンツが見つかりませんでした。"
      render :new
      return
    end

    if @report.save
      redirect_to public_post_path(content.post), notice: '通報が送信されました。'
    else
      render :new
    end
  end

  private

  def report_params
    params.require(:report).permit(:reporter_id, :reported_id, :content_id, :content_type, :reason)
  end
end

