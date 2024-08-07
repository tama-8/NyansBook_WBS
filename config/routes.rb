Rails.application.routes.draw do

 root 'public/homes#top'
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

# ゲストユーザー
  devise_scope :customer do
      post 'customers/guest_sign_in', to: 'public/sessions#guest_sign_in', as: :customers_guest_sign_in
  end
  # 会員側のルーティング
  namespace :public do

    get '/about', to: 'homes#about'

    

    # マイページ
    get 'mypage', to: 'customers#mypage', as: 'mypage'
    # ユーザー退会処理（ステータス更新）
    delete 'customers/withdraw', to: 'customers#withdraw', as: 'withdraw_customer'
    resources :customers,only: [:show, :edit, :update, :destroy]
    resources :posts, only: [:new, :create, :index, :show, :edit, :update, :destroy]
    resource :session, only: [:new, :create, :destroy]
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
