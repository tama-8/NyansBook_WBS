class ApplicationController < ActionController::Base
     # helper_method :current_customer?
     # helper_method :current_admin

#   def current_admin
#     # 現在ログインしている管理者を返す
#     # Devise を使用している場合は以下のように設定されていることが多い
#     current_customer if current_customer&.admin?
#   end
end
