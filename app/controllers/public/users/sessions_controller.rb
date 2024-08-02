module Public
    class Users::SessionsController < Devise::SessionsController
      def guest_sign_in
        user = User.guest
        if user
        sign_in user
        redirect_to user_path(user), notice: "guestuserでログインしました。"
        lse
        redirect_to new_user_session_path, alert: "ゲストユーザーが見つかりませんでした。"
        end
      end
    end 
end