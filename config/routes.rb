Rails.application.routes.draw do

  # 管理者用
  # URL /admin/sign_in ...
  devise_for :admins, controllers: {
    sessions: "admin/sessions"
  }

  # 会員用
  # URL /customers/sign_in ...
  devise_for :customers, controllers: {
    registrations: "public/registrations",
    sessions: 'public/sessions'
  }


  # 会員側のルーティング
  namespace :public do
    # トップページとアバウトページ
    root 'homes#top'
    get '/about', to: 'homes#about'

    # ゲストユーザー
    post 'users/guest_sign_in', to: 'application#guest_sign_in', as: :users_guest_sign_in

    # マイページ
    get 'mypage', to: 'users#mypage', as: 'mypage'
    # ユーザー退会処理（ステータス更新）
    patch 'users/withdraw', to: 'users#withdraw', as: 'withdraw_user'
    resources :users, only: [:show, :edit, :update] 
      
    end
  end


  # 管理側のルーティング
#   namespace :admin do
#     root 'homes#top'  # 管理側のトップページ
#     resources :users, only: [:index, :show, :edit, :update, :destroy]
#     resources :posts, only: [:index, :show, :destroy]
#     resources :comments, only: [:index, :show, :destroy]
#     resources :reports, only: [:index, :show, :update]
#     # その他の管理側ルーティングをここに記述
#   end

  # その他のルーティング...
