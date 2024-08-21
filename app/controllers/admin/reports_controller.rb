class Admin::ReportsController < ApplicationController
  before_action :authenticate_admin!

  def index
    # @reports = Report.includes(:reporter, :reported, :content)
    #                 .where.not(content_id: nil) # コンテンツが存在するものだけを表示
    #                 .order(created_at: :desc)
    @reports = Report.all
  end

  def delete_content
    @report = Report.find(params[:id])

    if @report.content
      @report.content.destroy
      @report.destroy # コンテンツと共に通報も削除
      redirect_to admin_reports_path, notice: "コンテンツと関連する通報が削除されました。"
    else
      @report.destroy # コンテンツが既にない場合も通報を削除
      redirect_to admin_reports_path, notice: "通報は削除されました。コンテンツは既に存在しませんでした。"
    end
  end

  def ignore
    @report = Report.find(params[:id])
    if @report.content
      @report.update(is_checked: true)
      notice_message = "通報は無視されました。"
    else
      @report.destroy
      notice_message = "通報は削除されました。コンテンツは既に存在しませんでした。"
    end

    redirect_to admin_reports_path, notice: notice_message
  end

  def toggle
    report = Report.find(params[:id])
    report.update(is_checked: !report.is_checked)
    redirect_to admin_reports_path, notice: "通報が更新されました。"
  end
end
