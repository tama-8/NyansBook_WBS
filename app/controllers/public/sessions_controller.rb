# frozen_string_literal: true

class Public::SessionsController < Devise::SessionsController
  before_action :configure_sign_in_params, only: [:create]
  before_action :check_empty_fields, only: [:create]

  GUEST_USER_EMAIL = "guest@example.com"

  def create
    super
  end

  def guest_sign_in
    customer = Customer.guest
    sign_in customer
    redirect_to public_customer_path(customer), notice: "ゲストユーザーとしてログインしました。"
  end

  def self.guest
    find_or_create_by!(email: GUEST_USER_EMAIL) do |customer|
      customer.password = SecureRandom.urlsafe_base64
      customer.name = "guestuser"
    end
  end

  protected
    def after_sign_in_path_for(resource)
      public_customer_path(resource)
    end

    def after_sign_out_path_for(resource)
      public_about_path
    end

    def configure_sign_in_params
      devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
    end

    def check_empty_fields
      if params[:customer][:email].blank? || params[:customer][:password].blank?
        flash[:alert] = "メールアドレス、パスワードを入力してください"
        redirect_to new_customer_session_path
      end
    end
end
