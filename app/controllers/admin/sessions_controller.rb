# frozen_string_literal: true

class Admin::SessionsController < Devise::SessionsController
  protected
    def after_sign_in_path_for(resource)
      flash[:notice] = I18n.t("devise.sessions.admin.signed_in") if resource.is_a?(Admin)
      admin_dashboard_path # ログイン後にリダイレクトするパスをダッシュボードページに設定
    end

    def after_sign_out_path_for(resource_or_scope)
      if resource_or_scope == :admin
        flash[:notice] = I18n.t("devise.sessions.admin.signed_out")
      else
        flash[:notice] = I18n.t("devise.sessions.signed_out")
      end
      new_admin_session_path # ログアウト後にリダイレクトするパス
    end
end
