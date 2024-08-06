class ApplicationController < ActionController::Base
    before_action :authenticate_customer!, except: [:top,:about]
    before_action :configure_permitted_parameters, if: :devise_controller?
    helper_method :current_user

   def current_user
      @current_user ||= User.find(session[:user_id]) if session[:user_id]
   end
    
 # def after_sign_in_path_for(resource)
    # case resource
    # when Admin
    #   admin_path
    # when Customer
    #   public_posts_path
    # else
    #   public_root_path
    # end
 # end

  def after_sign_out_path_for(resource)
    case resource
    when Admin
      admin_path
    when Customer
      about_path
    else
      public_withdraw_customer
    end
  end
  
  
  
   protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
  end
  
end
