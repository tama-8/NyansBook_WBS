module Public
  class CustomersController < ApplicationController
      # before_action :authenticate_customer!
     
      before_action :set_customer, only: [:show, :edit, :update, :destroy]
       before_action :ensure_guest_customer, only: [:edit,:update, :destroy]
      
      
      
      def show
          @customer = Customer.find(params[:id])
          @posts =@customer.posts   
      end
      
      def mypage 
          @customer = current_customer
         
      end
      
      def edit
         @customer = current_customer
      end
    
      def update
          @customer = current_customer
        
          if @customer.update(customer_params)
            flash[:notice] = '情報が更新されました。'
            redirect_to public_mypage_path
          else
            flash.now[:alert] = '情報の更新に失敗しました。'
            render :edit
          end
      end
    
      def withdraw
        @customer = current_customer
       if @customer.destroy
          flash[:notice] = '退会が完了しました。'
          redirect_to new_customer_registration_path
       else
          flash[:alert] = '退会に失敗しました。'
          redirect_to mypage_path
       end
      end
      
      
      private
      
      def set_customer
          @customer = current_customer
      end
    
       def ensure_guest_customer
          if @customer.email == "guest@example.com"
            redirect_to public_mypage_path, notice: "ゲストユーザーはプロフィール編集画面へ遷移できません。"
          end
       end
      
      def customer_params
           # ストロングパラメータを適用
          params.require(:customer).permit(:name, :email, :password, :password_confirmation, :image,:bio)
        
      end
      
       
  end
end
