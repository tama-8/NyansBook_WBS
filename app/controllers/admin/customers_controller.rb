class Admin::CustomersController < ApplicationController
    before_action :authenticate_admin!
    
    def index
        @customers = Customer.all
    end
    
    def show
        @customer = Customer.find(params[:id])
    end
    
    def destroy
      @customer = Customer.find(params[:id])
      @customer.destroy
      redirect_to admin_customers_path, notice: '会員が削除されました'
    end

    private

    def authenticate_admin!
      unless admin_signed_in?
        redirect_to new_admin_session_path, alert: '管理者としてログインしてください'
      end
    end
end
