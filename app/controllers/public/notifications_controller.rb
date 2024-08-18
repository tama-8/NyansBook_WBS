class Public::NotificationsController < ApplicationController
     before_action :authenticate_customer! # 顧客がログインしていることを確認
     
     # 通知の一覧を表示
    def index
      @notifications = current_customer.received_notifications.order(created_at: :desc)
     # 未読通知のカウントを取得
  @unread_notifications_count = @notifications.where(read: false).count
  
  Rails.logger.debug "@notifications: #{@notifications.inspect}"
  Rails.logger.debug "Unread notifications count: #{@unread_notifications_count}"
    end

    # 通知を既読にするアクション
  def mark_as_read
    notification = current_customer.received_notifications.find(params[:id])
    notification.update(read: true)
    notification.destroy  # 通知を削除
    redirect_to public_notifications_path notice: '通知を既読にしました。'
  end
end