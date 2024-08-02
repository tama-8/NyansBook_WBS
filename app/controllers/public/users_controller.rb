module Public
  class UsersController < ApplicationController
      before_action :authenticate_user!
      before_action :ensure_guest_user, only: [:edit]
      
      def index
         @users = User.all
      end
      
      def show
          @user = User.find(params[:id])
      end
      
      def create
          @user = User.new(user_params)
          if @user.save
            redirect_to @user
          else
            render 'new'
          end
      end
    
      def edit
          @user = User.find(params[:id])
      end
    
      def update
          @user = User.find(params[:id])
          if @user.update(user_params)
            redirect_to @user
          else
            render 'edit'
          end
      end
    
      def destroy
          @user = User.find(params[:id])
          @user.destroy
          redirect_to users_path
      end
    
      
      
      private
    
      def ensure_guest_user
        @user = User.find(params[:id])
        if @user.gest_user?
          redirect_to user_path(current_user) , notice: "ゲストユーザーはプロフィール編集画面へ遷移できません。"
        end
      end
      
      def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
      end
  end
end
