# frozen_string_literal: true

class Admin::SessionsController < Devise::SessionsController
  protected
  
  def after_sign_in_path_for(resource)
    admin_dashboard_path# ログイン後にリダイレクトするパスをダッシュボードページに設定
  end
  
  def after_sign_out_path_for(resource)
    new_admin_session_path # ログアウト後にリダイレクトするパス
  end
end
