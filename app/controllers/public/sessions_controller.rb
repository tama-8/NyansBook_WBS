# frozen_string_literal: true

class Public::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]
  def after_sign_in_path_for(resource)
    public_posts_path
    # 遷移先のパス
  end
  
  def guest_sign_in
    customer = Customer.guest
    sign_in customer
    redirect_to public_customer_path(customer), notice: 'ゲストユーザーとしてログインしました。'
  end
  GUEST_USER_EMAIL = "guest@example.com"
  def self.guest
    find_or_create_by!(email: GUEST_USER_EMAIL) do |user|
      customer.password = SecureRandom.urlsafe_base64
      customer.name = "guestuser"
    end
  end
  # GET /resource/sign_in
  # def new
    
  # end

  # POST /resource/sign_in
  # def create
  #   customer = Customer.find_by(email: params[:email])
  #   if customer && customer.authenticate(params[:password])
  #     # session[:user_id] = user.id
  #     # redirect_to root_path, notice: 'Logged in!'
  #   else
  #     flash.now[:alert] = 'Invalid email or password'
  #     render :new
  #   end
  # end

  # # DELETE /resource/sign_out
  # def destroy
  #   session[:_id] = nil
  #   redirect_to public_root_path, notice: 'Logged out!'
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
