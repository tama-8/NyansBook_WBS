module Public
  class CustomersController < ApplicationController
      before_action :authenticate_customer!
      before_action :ensure_guest_customer, only: [:edit]
      
      
      
      def show
          @customer = Customer.find(params[:id])
          @posts =@customer.posts   
      end
      
      
    
      def edit
          @customer = Customer.find(params[:id])
      end
    
      def update
           @customer = Customer.find(params[:id])
          if @customer.update(customer_params)
            redirect_to @customer
          else
            render 'edit'
          end
      end
    
      def destroy
           @customer = Customer.find(params[:id])
          @customer.destroy
          redirect_to customers_path
      end
    
      
      
      private
    
      def ensure_guest_customer
       @customer = Customer.find(params[:id])
        if @customer.gest_customer?
          redirect_to customer_path(current_customer) , notice: "ゲストユーザーはプロフィール編集画面へ遷移できません。"
        end
      end
      
      def customer_params
      params.require(:customer).permit(:name, :email, :password, :password_confirmation)
      end
  end
end
