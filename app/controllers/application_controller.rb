class ApplicationController < ActionController::Base
    before_action :authenticate_customer!, except: [:top,:about]
    before_action :configure_permitted_parameters, if: :devise_controller?
    helper_method :current_user
    helper_method :current_admin, :admin_signed_in?

   def current_user
      @current_user ||= User.find(session[:user_id]) if session[:user_id]
   end
    
  def after_sign_in_path_for(resource)
    case resource
    when Admin
      admin_customers_path
    when Customer
      public_posts_path
    else
      public_root_path
    end
  end

  def after_sign_out_path_for(resource)
    case resource
    when Admin
      new_admin_session_path # ログアウト後にリダイレクトするパス
    when Customer
      about_path
    else
      public_about_path
    end
  end
  
  # current_admin　nilのため追加
  def current_admin
    Rails.logger.debug "Current Admin session[:admin_id]: #{session[:admin_id]}"
    @current_admin ||= Admin.find_by(id: session[:admin_id]) if session[:admin_id]
    Rails.logger.debug "Current Admin: #{@current_admin.inspect}"
    @current_admin
  end
  
   protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
  end
  #管理者がログインしている場合に、その管理者の情報を取得
  def current_admin
    @current_admin ||= Admin.find_by(id: session[:admin_id]) if session[:admin_id]
  end
  
   def admin_signed_in?
    current_admin.present?
   end

  def authenticate_admin!
    unless admin_signed_in?
      redirect_to new_admin_session_path, alert: '管理者としてログインしてください'
    end
  end
  
end
