# frozen_string_literal: true

class Admin::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]
  # before_action :authenticate_admin!
  # skip_before_action :authenticate_admin!, only: [:new, :create]
  # その他のコード
  def create
    super do |admin|
      session[:admin_id] = admin.id
    end
  end
  
    protected

  def after_sign_in_path_for(resource)
    admin_customers_path# ログイン後にリダイレクトするパスを会員一覧ページに設定
  end
  
  def after_sign_out_path_for(resource_or_scope)
    new_admin_session_path # ログアウト後にリダイレクトするパス
  end
  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
