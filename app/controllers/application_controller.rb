class ApplicationController < ActionController::Base
  before_action :set_unread_notifications_count

  private
    def set_unread_notifications_count
      if current_customer.present?
        @unread_notifications_count = current_customer.received_notifications.unread.count
      else
        @unread_notifications_count = 0
      end
    end
end
