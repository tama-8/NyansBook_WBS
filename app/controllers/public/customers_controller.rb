module Public
  class CustomersController < ApplicationController
    before_action :authenticate_customer!
    before_action :set_customer, only: [:show, :edit, :update, :destroy, :following, :followers]
    before_action :ensure_guest_customer, only: [:edit, :update, :destroy]
    before_action :correct_customer, only: [:edit, :update]
    
    

    def show
      @posts = @customer.posts.order(created_at: :desc)  # 新規投稿順に並べ替え
      @customer = Customer.find(params[:id])
    end
    
    def mypage 
      @customer = current_customer
    end
    
    def edit
    end
  
    def update
      if @customer.update(customer_params)
        flash[:notice] = '情報が更新されました。'
        redirect_to public_mypage_path
      else
        flash.now[:alert] = '情報の更新に失敗しました。'
        render :edit
      end
    end
  
    def withdraw
      if current_customer.destroy
        flash[:notice] = '退会が完了しました。'
        redirect_to new_customer_registration_path
      else
        flash[:alert] = '退会に失敗しました。'
        redirect_to public_mypage_path
      end
    end
    
    def following
      @title = "Following"
      @customer  = Customer.find(params[:id])
      @customers = @customer.following.page(params[:page]).per(10)
      render 'show_follow'
    end
  
    def followers
      @title = "Followers"
      @customer = Customer.find(params[:id])
      @customers = @customer.followers.page(params[:page]).per(10)
      render 'show_follow'
    end
    
    private
    
    def set_customer
      @customer = Customer.find(params[:id])
    end
  
    def ensure_guest_customer
      if @customer.email == Customer::GUEST_USER_EMAIL
        redirect_to public_mypage_path, notice: "ゲストユーザーはプロフィール編集画面へ遷移できません。"
      end
    end

    def correct_customer
      redirect_to public_mypage_path, alert: '権限がありません。' unless @customer == current_customer
    end
    
    def customer_params
      # ストロングパラメータを適用
      params.require(:customer).permit(:name, :email, :password, :password_confirmation, :image, :bio)
    end
  end
end
