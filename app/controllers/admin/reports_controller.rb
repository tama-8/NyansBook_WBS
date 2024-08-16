class Admin::ReportsController < ApplicationController
   before_action :authenticate_admin!
   
  def index
    @reports = Report.includes(:reporter, :reported, :content).order(created_at: :desc)
  end
  
  def delete_content
  @report = Report.find(params[:id])
  @report.content.destroy

  redirect_to admin_reports_path, notice: 'コンテンツが削除されました。'
end

def ignore
  @report = Report.find(params[:id])
  @report.update(is_checked: true)

  redirect_to admin_reports_path, notice: '通報は無視されました。'
end

def toggle
  @report = Report.find(params[:id])
  @report.update(is_checked: !@report.is_checked)

  redirect_to admin_reports_path, notice: '通報の確認状態が更新されました。'
end
end
