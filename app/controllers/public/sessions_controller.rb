# frozen_string_literal: true

class Public::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]
  def after_sign_in_path_for(resource)
    public_posts_path
    # 遷移先のパス
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
