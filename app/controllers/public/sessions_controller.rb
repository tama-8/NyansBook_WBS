# frozen_string_literal: true

class Public::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]
  
  GUEST_USER_EMAIL = "guest@example.com"
  
  def guest_sign_in
    customer = Customer.guest
    sign_in customer
    redirect_to public_customer_path(customer), notice: 'ゲストユーザーとしてログインしました。'
  end

  def self.guest
    find_or_create_by!(email: GUEST_USER_EMAIL) do |user|
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
end
